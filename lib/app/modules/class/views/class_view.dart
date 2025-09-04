import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/class_controller.dart';


class ClassView extends GetView<ClassController> {
  const ClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的课程'),
        centerTitle: true,
      ),
      body: Obx(() {
        final wrapper = controller.courseWrapper.value;

        if (wrapper.channelList == null || wrapper.channelList!.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: wrapper.channelList!.length,
          itemBuilder: (context, index) {
            final channel = wrapper.channelList![index];
            final content = channel.content;
            if (content == null) return const SizedBox();

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 班级信息
                    Text(
                      '班级ID: ${content.id ?? '未知'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // 课程列表
                    if (content.course?.data != null)
                      ...content.course!.data!.map((course) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            //color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '课程名称: ${course.name ?? '未知'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '课程ID: ${course.id ?? '未知'}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                '教师: ${course.teacherfactor ?? '未知'}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            );

          },
        );
      }),
    );
  }
}
