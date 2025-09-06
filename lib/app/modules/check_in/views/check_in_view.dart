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
      child: ListView(
        children: [
          tips(),
          searchForActive(),
          getPosition(),
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
          SizedBox(height: 5,),
          Container(
            margin: const EdgeInsets.all(10),
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.positionSignController.positionSign();
              },
              child: const Text("位置签到"),
            ),
          ),
          SizedBox(height: 5,),
          Container(
            margin: const EdgeInsets.all(10),
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.commonSignController.commonSign();
              },
              child: const Text("普通签到"),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchForActive() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // 边框颜色
          width: 2, // 边框宽度
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(10),
      height: 180,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(15, 10, 0, 0),
            alignment: Alignment.topLeft, // 正确写法
            height: 30,
            child: const Text("当前正在进行的签到活动:", style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 10),
          Container(
            height: 50,

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

  Widget getPosition() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // 边框颜色
          width: 2, // 边框宽度
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(10),
      height: 180,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(15, 10, 0, 0),
            alignment: Alignment.topLeft, // 正确写法
            height: 30,
            child: const Text("当前的位置:", style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 10),
          Container(
            height: 50,

            child: Obx(() {
              if (controller.locationController.isLoading.value) {
                return CircularProgressIndicator();
              } else {
                return Text(
                  "经度:${controller.locationController.longitude.value},纬度:${controller.locationController.latitude.value}",
                );
              }
            }),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            height: 50,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(onPressed: () {
                    controller.locationController.getLocation();
                  }, child: Text("获取位置")),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(onPressed: () {}, child: Text("手动输入")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tips() {
    return StatefulBuilder(
      builder: (context, setState) {
        final controller = AnimationController(
          vsync: Scaffold.of(context),
          duration: const Duration(seconds: 15),
        )..repeat();

        const text =
            "🔥🔥请在签到前先点击刷新获取签到活动，在点击获取位置获取位置信息，需要自行判断签到类型，暂不支持群聊内的位置签到（二维码签到可以），有任何问题请到用户选项下反馈，应用会持续更新🔥🔥";

        return Container(
          height: 30,
          width: double.infinity,
          color: Colors.deepOrange,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 计算文字真实宽度
              final textPainter = TextPainter(
                text: const TextSpan(
                  text: text,
                  style: TextStyle(color: Colors.white),
                ),
                textDirection: TextDirection.ltr,
              )..layout();

              final textWidth = textPainter.width;
              final start = constraints.maxWidth;
              final end = -textWidth;

              return AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  final dx = start + (end - start) * controller.value;
                  return Transform.translate(
                    offset: Offset(dx, 0),
                    child: child,
                  );
                },
                // 关键：给文字自己的宽度，避免被父容器裁剪
                child: SizedBox(
                  width: textWidth,
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }


}
