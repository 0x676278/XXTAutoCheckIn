import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/check_in_controller.dart';

class CheckInView extends GetView<CheckInController> {
  const CheckInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CheckInView'), centerTitle: true),
      body: CheckMenu(),
    );
  }

  Widget CheckMenu() {
    return Container(
      child: Column(
        children: [
          searchForActive(),
          Container(
            margin: const EdgeInsets.all(10),
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed("/scan");
              },
              child: const Text("扫码签到"),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchForActive() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 120,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 30,
            margin: const EdgeInsets.all(10),
            child: Obx(() {
              if (controller.is_loading.value) {
                return CircularProgressIndicator();
              } else {
                if (!controller.hasActive.value) {
                  return const Text("点击刷新获取正在进行的签到活动，这可能需要数十秒");
                } else {
                  return Text("当前正在进行的签到活动:${controller.activeName.value}");
                }
              }
            }),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.searchForActive();
              },
              child: const Text("刷新"),
            ),
          ),
        ],
      ),
    );
  }
}
