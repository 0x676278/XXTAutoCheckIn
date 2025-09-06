import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserView extends GetView<UserController> {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的'), centerTitle: true),
      body: userSection(),
    );
  }

  Widget userSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          userInfo(),
          const SizedBox(height: 16),
          const Divider(thickness: 1),
          const SizedBox(height: 16),
          frendsAuth(),
          const SizedBox(height: 16),
          exit(),
          const SizedBox(height: 16),
          feedback(),
        ],
      ),
    );
  }

  Widget userInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              controller.pic.value,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // 加载失败显示占位头像
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, size: 50),
                );
              },
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.name.value??"",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,

                  ),

                ),
                const SizedBox(height: 8),
                Text(
                  controller.stuId.value??"",
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.schoolName.value ?? "",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget frendsAuth() {
    return InkWell(
      onTap: (){
        Get.snackbar("功能正在开发中","");
      },
      child: Card(
        color: Colors.yellow[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              "好友账号绑定",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget exit() {
    return InkWell(
      onTap: () {
        controller.changeUser();
      },
      child: Card(
        color: Colors.orange[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              "切换账号",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget feedback() {
    return InkWell(
      onTap: () {
        final TextEditingController controller = TextEditingController();

        Get.dialog(
          AlertDialog(
            title: const Text("反馈"),
            content: TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "请输入您的反馈内容...",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // 关闭对话框
                },
                child: const Text("取消"),
              ),
              ElevatedButton(
                onPressed: () {
                  String feedbackText = controller.text;
                  // 在这里处理提交逻辑，比如上传到服务器
                  debugPrint("用户反馈内容: $feedbackText");

                  Get.back(); // 关闭对话框
                  Get.snackbar(
                    "反馈成功",
                    "感谢您的反馈！",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.withOpacity(0.7),
                    colorText: Colors.white,
                    duration: Duration(seconds: 1)
                  );
                },
                child: const Text("提交"),
              ),
            ],
          ),
        );
      },
      child: Card(
        color: Colors.blue[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              "反馈",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );



}


}
