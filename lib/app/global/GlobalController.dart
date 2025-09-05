import 'dart:convert';

import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import './dio_client.dart';
import 'DateBaseHelper.dart';
import 'WebSocketController.dart';
import '../services/chaoxinApi.dart';
class GlobalController extends GetxController {

  /**
   * 全局变量
   */
  var uid= ''.obs;
  var is_login = false.obs;
  var cookies = [].obs;
  var fid = ''.obs;
  var schoolName = ''.obs;
  var userName = ''.obs;
  var stuId = ''.obs;
  var pic = ''.obs;

  var index = 0.obs;//当前页面

  //当前正在进行的签到活动的activedId
  var activeId = ''.obs;
  var classId = ''.obs;
  var courseId = ''.obs;


  /**
   * 启动时读取本地全局数据
   */
  @override
  Future<void> onInit() async {
    //初始化dio
    DioClient.setup();
    //初始化controller

    //初始化保存器
    await GetStorage.init('loginInfo');
    final loginInfo = GetStorage('loginInfo');
    // 从本地存储中读取数据
    final uid = loginInfo.read('uid') ?? '';
    final cookies = loginInfo.read('cookies') ?? '';
    final is_login = loginInfo.read('is_login') ?? false;
    final fid = loginInfo.read('fid') ?? '';
    final schoolName = loginInfo.read('schoolName') ?? '';
    final userName = loginInfo.read('userName') ?? '';
    final stuId = loginInfo.read('stuId') ?? '';
    final pic = loginInfo.read('pic') ?? '';
    // 调用保存方法更新状态
    saveLoginInfo(uid, fid, cookies, is_login,schoolName,userName,stuId,pic);
  }

  @override
  void onClose() {


  }


  /**
   * 保存全局数据
   */

  void saveLoginInfo(var uid,var fid, var cookies, var is_login,var schoolName,var userName,var stuId,var pic) {
    print('保存全局数据');
    // 更新内存中的状态
      this.uid.value = uid;
      this.pic.value = pic;
      this.fid.value = fid;
      this.cookies.value = cookies;
      this.is_login.value = is_login;
      this.schoolName.value = schoolName;
      this.userName.value = userName;
      this.stuId.value = stuId;

    //保存数据到本地
    final loginInfo = GetStorage('loginInfo');
    loginInfo.write('uid', uid);
    loginInfo.write('cookies', cookies);
    loginInfo.write('is_login', is_login);
    loginInfo.write('fid', fid);
    loginInfo.write('schoolName', schoolName);
    loginInfo.write('userName', userName);
    loginInfo.write('stuId', stuId);
    loginInfo.write('pic', pic);



  }


  //这里用于检测页面是否发生变换
  void tabChanged(int index){
print('页面发生变换');
    this.index.value = index;
  }





}

