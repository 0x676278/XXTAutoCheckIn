import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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


    // 检查本地 cookie 文件是否存在
    final dir = Directory(cookiePath);
    if (await dir.exists()) {
      print("Cookie 文件夹存在");
      final files = dir.listSync();
      print("Cookie 文件夹内容: ${files.map((e) => e.path).toList()}");
    } else {
      print("Cookie 文件夹不存在，会自动创建");
    }


    // 添加拦截器
    dio.interceptors.add(CookieManager(cookieJar));

    dio.options.headers = {
      //"User-Agent": "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.108 Safari/537.36",
      "User-Agent":"Mozilla/5.0 (iPhone; CPU iPhone OS 16_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 (schild:16af8f4ce32c6ffcd6c77ae19bcb6c09) (device:iPhone14,6) Language/zh-Hans com.ssreader.XueZaiXiDianStudy/ChaoXingStudy_1000149_6.2.8_ios_phone_202409301548_235 (@Kalimdor)_9473433864088185778"
    };
    // 从文件加载所有域名 cookies
    await loadCookies();

  }


  /**
   * 设置cookies
   */
  Future<void> loadCookies() async {
    // 对于每个需要访问的域名都加载 cookies
    List<String> domains = [
      //"https://passport2-api.chaoxing.com",
      "https://sso.chaoxing.com",
      "http://mooc1-api.chaoxing.com/mycourse/backclazzdata",
      "https://mobilelearn.chaoxing.com/ppt/activeAPI/taskactivelist",
      "https://mobilelearn.chaoxing.com/v2/apis/active/student/activelist",
    ];

    for (var domain in domains) {
      List cookies = await cookieJar.loadForRequest(Uri.parse(domain));
      print("已加载 $domain 的 Cookies: $cookies");
    }

    //在这里检查cookies是否过期
    bool is_expired = false;
    for (var domain in domains) {
      is_expired = await isCookieExpired(domain);
      if(is_expired){
        //cookies过期了
        //TODO 重新登录
        Get.toNamed("/login");
        break;
      }
    }
    if(!is_expired){
      //cookies没有过期
      print("所有cookies均未过期");
    }
  }


  Future<void> clearAllCookies() async {
    await cookieJar.deleteAll();
    print("已清除所有 cookies");
    // 重新加载cookies
    await loadCookies();
  }


  /**
   * 检查cookies是否过期
   */
  Future<bool> isCookieExpired(String url) async {
    List cookies = await cookieJar.loadForRequest(Uri.parse(url));

    if (cookies.isEmpty) return true; // 没有 cookie，视为过期

    final now = DateTime.now();

    for (var cookie in cookies) {
      if (cookie.expires != null && cookie.expires!.isBefore(now)) {
        return true; // 有过期 cookie
      }
    }
    return false; // cookie 都有效
  }


  /**
   * 超星登录方法，登录成功后 cookies 会自动保存到文件
   */
  Future chaoxingLogin(String username, String password) async {
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
      //Get.snackbar("登陆", data["msg"]);
      final ssoUrl = data["url"];
      if (ssoUrl != null) {
        final ssoResponse = await dio.get(ssoUrl);
        if (ssoResponse.statusCode == 200) {
          print("SSO 登录完成");
          print(jsonDecode(ssoResponse.data)["msg"]);
        }
        // 获取 uid
        var uid = jsonDecode(ssoResponse.data)["msg"]["uid"];
        //获取fid
        var fid = jsonDecode(ssoResponse.data)["msg"]["fid"];
        if(jsonDecode(ssoResponse.data)["msg"]["isCertify"]==0){
          //未认证
          Get.snackbar("登陆错误", "当前账号未认证，请先到学习通-账号管理-绑定学校");
          return null;
        }
        globalController.saveLoginInfo(uid.toString(),fid.toString(), [], true,jsonDecode(ssoResponse.data)["msg"]["schoolname"],jsonDecode(ssoResponse.data)["msg"]["name"],jsonDecode(ssoResponse.data)["msg"]["uname"],jsonDecode(ssoResponse.data)["msg"]["pic"]); // cookies 由 PersistCookieJar 管理
        //展示数据
        print("登录成功");
        print("cookies: ${dio.options.headers['cookie']}");
        print("uid: $uid");
        //登陆后重新加载cookies
        await loadCookies();
        return jsonDecode(ssoResponse.data)["msg"];
      }
      return null;

    } catch (e) {
      print("登录异常: $e");

      return null;
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
//     // 遍历课程列表
//     if (courseWrapper.channelList != null) {
//       for (var channel in courseWrapper.channelList!) {
//         print("目录名称: ${channel.cataName}");
//
//         final classId = channel.content?.id; // 班级id
//         final className = channel.content?.name; // 班级名称
//
//         if (channel.content?.course?.data != null) {
//           for (var course in channel.content!.course!.data!) {
//             print("课程名: ${course.name}");
//             print("课程id: ${course.id}");
//             print("班级id: $classId");
//             print("班级名称: $className");
//           }
//         }
//       }
//     }


    return courseWrapper;
    }


/**
 * 查询签到任务
 */
  Future getSignTask(var fid,var courseId, var classId) async{
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
   var activeList = response.data["data"]["activeList"];
  return activeList;

  }


/**
 * 遍历查询可签到任务
 */
Future searchForSignTask() async{
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
          var res = await getSignTask(globalController.fid.value, course.id!, classId!);
          var activeList = res;
          if (activeList != null) {
            for (var active in activeList) {
              if (active["nameOne"] == "教务课程签到" && active["status"] == 1) {
                //这里考虑到不可能同时有多个签到活动，所以直接返回
                //构造返回结构体
                var result  = {
                  "courseId":course.id,
                  "classId":classId,
                  "activeId":active["id"],
                  "name":course.name,
                };
                return result;
              }
              print("签到任务名称：${active["name"]}");
            }
          }
          else {
            // 课程没有可签到任务
            print("课程没有可签到任务");
          }
        }
      }
    }
    return null;
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
Future qrSign(var activeId,var enc,var fid)async{
  final response = await dio.get(
    'https://mobilelearn.chaoxing.com/pptSign/stuSignajax',
    queryParameters: {
      "activeId":activeId.toString(),
      "enc":enc.toString(),
      "fid":fid.toString(),
    },
    options: Options(
      contentType: Headers.formUrlEncodedContentType,
    ),
  );
  //这里不需要他的返回值
  print("!!!!!!!!!!!二维码签到结果：${response.data}");
  return response.data;
}


Future getValidate()async{
  final response = await dio.get(
    'https://cx.micono.eu.org/api/validate',
    options: Options(
      contentType: Headers.formUrlEncodedContentType,
    ),
  );
  print("!!!!!!!!!!!获取校验结果：${response.data}");
  return response.data["data"]["validate"];
}


  /**
   * 有滑块验证时需要二次请求
   */
  Future secondQrSign(var enc,var activeId,var uid,var latitude,var longitude,var fid,var validate) async{
  final response = await dio.get(
    'https://mobilelearn.chaoxing.com/pptSign/stuSignajax',
    queryParameters: {
      "enc":enc,
      "activeId":activeId,
      "uid":uid,
      "clientip":"",
      "location":"",
      "latitude":latitude,
      "longitude":longitude,
      "fid":fid,
      "appType":"15",
      "validate":validate,
      "vpProbability":"",
      "vpStrategy":"",
    },
    options: Options(
      contentType: Headers.formUrlEncodedContentType,
    ),
  );
  print("!!!!!!!!!!!二次签到结果：${response.data}");
  return response.data;

}


}
