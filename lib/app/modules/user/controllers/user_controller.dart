import 'package:get/get.dart';

import '../../../services/chaoxinApi.dart';

class UserController extends GetxController {
  //TODO: Implement UserController
  final chaoxinapi = Get.find<Chaoxinapi>();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;



  Future testApi() async{
    print("------------开始测试登陆------------");
    var result = await chaoxinapi.chaoxingLogin('18652804769','GB2099816905');
    print("登录结果：$result");

    print("------------开始测试获取课程表------------");
    var result1 = await chaoxinapi.getClassTable();
    print("课程表结果：$result1");

    print("------------开始测试获取签到任务------------");
    var result2 = await chaoxinapi.getSignTask(16820,254713480,126055093);
    print("签到任务结果：$result2");


  }
}
