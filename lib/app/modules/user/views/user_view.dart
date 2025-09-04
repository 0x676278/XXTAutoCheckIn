import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserView extends GetView<UserController> {
  const UserView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UserView'), centerTitle: true),
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
            await controller.testApi();
          },
          child: const Text("测试"),
        ),
      ),
    );
  }
}
