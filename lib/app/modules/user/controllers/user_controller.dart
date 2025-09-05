import 'package:autocheckin/app/services/chaoxinApi.dart';
import 'package:get/get.dart';

import '../../../global/GlobalController.dart';
import '../../../global/dio_client.dart';

class UserController extends GetxController {
  //TODO: Implement UserController
  //引入全局控制器
  final GlobalController globalController = Get.find<GlobalController>();
  final Chaoxinapi chaoxinapi = Get.find<Chaoxinapi>();
//要展示的数据
 var name = ''.obs;
 var pic = ''.obs;
 var stuId = ''.obs;
 var schoolName = ''.obs;

  final count = 0.obs;
  @override
  void onInit() async{
    super.onInit();
    //test登陆
   // await chaoxinapi.chaoxingLogin("18652804769", "GB2099816905");
    //从全局控制器获取数据
    getUserInfo();
    // 页面监听器
    pageListener();

  }
  /**
   * 获取用户信息
   */
  void getUserInfo(){
    name.value = globalController.userName.value;
    pic.value = globalController.pic.value;
    stuId.value = globalController.stuId.value;
    schoolName.value = globalController.schoolName.value;
    print(name.value);
    print(pic.value);
    print(stuId.value);
    print(schoolName.value);
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

Future changeUser() async{
  await chaoxinapi.clearAllCookies();
  globalController.saveLoginInfo("", "", [], false, "", "", "", "");
  Get.toNamed("/login");
}


  /**
   * 页面监听器
   */
  void pageListener() async {
    // 监听 count 的变化
    ever(globalController.index, (value) async{
      if (value == 2) {
        print("正在刷新");
        getUserInfo();
      }
    });
  }


}
