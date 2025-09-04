import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../global/GlobalController.dart';
import '../moudel/courseModel.dart';

class Chaoxinapi extends GetxController {
  final globalController = Get.find<GlobalController>();
  final Dio dio = Dio();
  late PersistCookieJar cookieJar;
  //参数
  var classId=0.obs;

  @override
  Future<void> onInit() async {
    // 获取应用文件目录，用于保存 cookie
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String cookiePath = "${appDocDir.path}/cookies";

    // 使用 PersistCookieJar 保存到文件
    cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));

    // 添加拦截器
    dio.interceptors.add(CookieManager(cookieJar));

    dio.options.headers = {
      "User-Agent": "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.108 Safari/537.36",

    };
    // 从文件加载所有域名 cookies
    await loadCookies();
  }


  /**
   * 从文件加载 cookies
   */
  Future<void> loadCookies() async {
    // 对于每个需要访问的域名都加载 cookies
    List<String> domains = [
      "https://passport2-api.chaoxing.com",
      "https://sso.chaoxing.com",
      "http://mooc1-api.chaoxing.com/mycourse/backclazzdata",
      "https://mobilelearn.chaoxing.com/ppt/activeAPI/taskactivelist",
      "https://mobilelearn.chaoxing.com/v2/apis/active/student/activelist",
    ];

    for (var domain in domains) {
      List cookies = await cookieJar.loadForRequest(Uri.parse(domain));
      print("已加载 $domain 的 Cookies: $cookies");
    }
  }


  /**
   * 超星登录方法，登录成功后 cookies 会自动保存到文件
   */
  Future<bool> chaoxingLogin(String username, String password) async {
    try {
      final response = await dio.post(
        'https://passport2-api.chaoxing.com/v11/loginregister',
        data: {"uname": username, "code": password},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      // 解析 JSON
      Map<String, dynamic> data;
      if (response.data is String) {
        data = jsonDecode(response.data);
      } else {
        data = response.data;
      }

      print("登录验证响应: $data");
      final ssoUrl = data["url"];
      if (ssoUrl != null) {
        final ssoResponse = await dio.get(ssoUrl);
        if (ssoResponse.statusCode == 200) {
          print("SSO 登录完成");
        }
        // 获取 uid
        var uid = jsonDecode(ssoResponse.data)["msg"]["uid"];
        globalController.saveLoginInfo(uid.toString(), [], true); // cookies 由 PersistCookieJar 管理
        //展示数据
        print("登录成功");
        print("cookies: ${dio.options.headers['cookie']}");
        print("uid: $uid");
      }

      return true;
    } catch (e) {
      print("登录异常: $e");
      return false;
    }
  }

  /**
   * 获取课程表
   */
  Future getClassTable() async{
    final response = await dio.get(
      'http://mooc1-api.chaoxing.com/mycourse/backclazzdata',
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    //序列化
    Map<String, dynamic> data;
    if (response.data is String) {
    data = jsonDecode(response.data);
    } else if (response.data is Map<String, dynamic>) {
    data = response.data;
    } else {
    throw Exception("未知响应类型: ${response.data.runtimeType}");
    }

// 2. 使用实体类解析
    final courseWrapper = CourseDataWrapper.fromJson(data);

// 3. 访问课程信息
    // 遍历课程列表
    if (courseWrapper.channelList != null) {
      for (var channel in courseWrapper.channelList!) {
        print("目录名称: ${channel.cataName}");

        final classId = channel.content?.id; // 班级id
        final className = channel.content?.name; // 班级名称

        if (channel.content?.course?.data != null) {
          for (var course in channel.content!.course!.data!) {
            print("课程名: ${course.name}");
            print("课程id: ${course.id}");
            print("班级id: $classId");
            print("班级名称: $className");
          }
        }
      }
    }



    return courseWrapper;
    }


/**
 * 查询签到任务
 */
  Future<bool> getSignTask(int fid,int courseId, int classId) async{
    final response = await dio.get(
      'https://mobilelearn.chaoxing.com/v2/apis/active/student/activelist',
      queryParameters: {
        "fid": fid.toString(),
        "courseId": courseId.toString(),
        "classId": classId.toString(),
        "howNotStartedActive": "0",
        "_": DateTime.now().millisecondsSinceEpoch.toString()
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    //序列化
   print("签到任务结果：${response.data}");
   var activeList = response.data["activeList"];
   if(activeList!=null){
     return true;
    for(var active in activeList){
      print("签到任务名称：${active["name"]}");
    }
   }
   return false;

  }


/**
 * 遍历查询可签到任务
 */
void searchForSignTask() async{
  //获取课程表
  var courseWrapper = await getClassTable();
  //遍历课程表
  if (courseWrapper.channelList != null) {
    for (var channel in courseWrapper.channelList!) {
      final classId = channel.content?.id; // 班级id
      final className = channel.content?.name; // 班级名称
      if (channel.content?.course?.data != null) {
        for (var course in channel.content!.course!.data!) {
          //查询签到任务
          var isSign = await getSignTask(16820, course.id!, classId!);
          if(isSign){
            print("班级名称：$className");
            print("课程名称：${course.name}");
            print("班级id：$classId");
            print("课程id：${course.id}");
          }
        }
      }
    }
  }
}


/**
 * 预先签到
 */
Future preSign(var courseId,var classId,var activeId,var uid) async{
  final response = await dio.get(
    'https://mobilelearn.chaoxing.com/newsign/preSign',
    queryParameters: {
      "courseId":courseId.toString(),
      "classId": classId.toString(),
      "activePrimaryId":activeId.toString(),
      "general": "1",
      "sys": "1",
      "ls": "1",
      "appType": "15",
      "tid": "",
      "uid": uid.toString(),
      "ut": "s",

    },
    options: Options(
      contentType: Headers.formUrlEncodedContentType,
    ),
  );
  //这里不需要他的返回值

}


/**
 * 普通签到
 */
Future commonSign(var activeId)async{
  final response = await dio.get(
    'https://mobilelearn.chaoxing.com/pptSign/stuSignajax',
    queryParameters: {
    "activeId":activeId.toString(),

    },
    options: Options(
      contentType: Headers.formUrlEncodedContentType,
    ),
  );
  //这里不需要他的返回值
}


/**
 * 位置签到
 */
Future positionSign(var address,var activeId,var latitude,var longitude,var fid) async{
  final response = await dio.get(
    'https://mobilelearn.chaoxing.com/pptSign/stuSignajax',
    queryParameters: {
      "address":address.toString(),
      "activeId":activeId.toString(),
      "latitude":latitude.toString(),
      "longitude":longitude.toString(),
      "fid":fid.toString(),
      "appType":"15",
      "ifTiJiao":"1",
    },
    options: Options(
      contentType: Headers.formUrlEncodedContentType,
    ),
  );
  //这里不需要他的返回值

}


/**
 * 直接获取正确的位置信息
 */
Future getPosition(var activeId)async{
  final response = await dio.get(
    'https://mobilelearn.chaoxing.com/v2/apis/active/getPPTActiveInfo?activeId=${activeId}',
    queryParameters: {
      "activeId":activeId.toString(),
    },
    options: Options(
      contentType: Headers.formUrlEncodedContentType,
    ),
  );
  //这里不需要他的返回值
}


/**
 * 二维码签到
 */




}
