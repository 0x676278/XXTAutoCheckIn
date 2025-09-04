import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/class_controller.dart';

class ClassView extends GetView<ClassController> {
  const ClassView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClassView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ClassView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
