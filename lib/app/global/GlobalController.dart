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

  var index = 0.obs;//当前页面


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
    // 调用保存方法更新状态
    saveLoginInfo(uid, cookies, is_login);
  }

  @override
  void onClose() {


  }


  /**
   * 保存全局数据
   */

  void saveLoginInfo(var uid, var cookies, var is_login) {
    print('保存全局数据');
    // 更新内存中的状态
    if (uid.isNotEmpty) {
      this.uid.value = uid;
    }

      this.cookies.value = cookies;

    this.is_login.value = is_login;

    //保存数据到本地
    final loginInfo = GetStorage('loginInfo');
    loginInfo.write('uid', uid);
    loginInfo.write('cookies', cookies);
    loginInfo.write('is_login', is_login);



  }


  //这里用于检测页面是否发生变换
  void tabChanged(int index){
print('页面发生变换');
    this.index.value = index;
  }





}

