import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'GlobalController.dart';

class WebSocketController extends GetxController {
  late IOWebSocketChannel _channel;


  // 存储收到的消息
  RxList<String> messages = <String>[].obs;

  // 连接状态
  RxBool isConnected = false.obs;

  // 初始化连接
  void connect(String url) {
    _channel = IOWebSocketChannel.connect(url);

    isConnected.value = true;
    print("已经建立socket连接");

    Get.snackbar("提示", "已与服务器建立socket连接");



    // 监听服务端消息
    _channel.stream.listen((event) {
      messages.add(event);
      //TODO这里处理接收到的消息

    },
        onDone: () {
      isConnected.value = false;


      print("WebSocket 已断开");
    },
        onError: (error) {
      isConnected.value = false;

      Get.snackbar("提示", "与服务器的socket连接已断开");
      print("WebSocket 出错: $error");
    });
  }

  // 发送消息
  void sendMessage(String message) {
    if (isConnected.value) {

      _channel.sink.add(message);
      messages.add(message);
    } else {
      print("WebSocket 未连接");
    }
  }

  // 断开连接
  void disconnect() {
    _channel.sink.close(status.normalClosure);
    isConnected.value = false;
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
