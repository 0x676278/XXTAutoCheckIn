import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<Dio> initDioWithCookie() async {
  final dio = Dio();

  // 获取应用文档目录
  final dir = await getApplicationDocumentsDirectory();
  final cookiePath = "${dir.path}/cookies";

  // 持久化 CookieJar
  final cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));

  // 添加拦截器
  dio.interceptors.add(CookieManager(cookieJar));

  return dio;
}
