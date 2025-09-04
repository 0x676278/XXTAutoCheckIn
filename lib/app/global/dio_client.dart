import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './GlobalController.dart';

class DioClient {

  static final Dio dio = Dio(BaseOptions(
    //baseUrl: 'http://localhost:8080',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));


  static bool _initialized = false; // 初始化标记

  // 初始化拦截器
  static void setup() {
    if (_initialized) return; // 已初始化就直接返回
    _initialized = true;

    final globalController = Get.find<GlobalController>();
    print("初始化dio拦截器.....");

    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 自动带 token
          // if (globalController.token.value.isNotEmpty) {
          //   options.headers['authentication'] = globalController.token.value;
          // }
          //浏览器标识
          //options.headers["User-Agen"]="Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.108 Safari/537.36";
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 全局错误处理
          if(response.data['code']!=1){
            print(response);
            Get.snackbar(
              "提示",
              response.data["msg"],
              duration: const Duration(seconds: 3), // 显示 3 秒
              backgroundColor: Colors.red, // 可选：背景颜色
              colorText: Colors.black, // 可选：文字颜色
            );

          }
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          final statusCode = e.response?.statusCode;
          switch (statusCode) {
            case 401:
            // token 过期
              Get.snackbar("提示", "您没有访问权限");
            print("token过期");
              globalController.is_login.value = false;
              // 可以清除缓存的 token
              break;

            case 403:
              print("403：无权限访问");
              Get.snackbar("提示", "您没有访问权限");
              break;

            case 404:
              print("404：接口不存在");
              Get.snackbar("提示", "接口不存在");
              break;

            case 500:
              print("500：服务器错误");
              Get.snackbar("错误", "服务器开小差了");
              break;

            default:
              print("其他错误：$statusCode");
              Get.snackbar("网络错误", e.message ?? "未知错误");
          }

          // 把错误继续传下去（如果需要全局拦截不传递，可以不调用 next）
          return handler.next(e);
        },

      ),
    );
  }
}
