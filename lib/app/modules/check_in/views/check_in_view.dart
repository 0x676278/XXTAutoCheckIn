import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/check_in_controller.dart';

class CheckInView extends GetView<CheckInController> {
  const CheckInView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckInView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CheckInView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
