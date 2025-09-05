import 'package:autocheckin/app/global/GlobalController.dart';
import 'package:autocheckin/app/services/chaoxinApi.dart';
import 'package:get/get.dart';

class CheckInController extends GetxController {
  //TODO: Implement CheckInController
  var is_loading = false.obs;
  var activeName = "".obs;
  var hasActive = false.obs;

  final Chaoxinapi chaoxinapi = Get.put(Chaoxinapi());
  final GlobalController globalController = Get.put(GlobalController());

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


  Future searchForActive() async{
    is_loading.value = true;
    var res = await chaoxinapi.searchForSignTask();
    if(res==null){
      Get.snackbar("查询签到", "当前没有可签到任务");
      hasActive.value = false;
      is_loading.value = false;
      return;
    }
    else{
      //当前有可签到任务
      //写入全局变量
      globalController.activeId.value = res["activeId"];
      globalController.classId.value = res["classId"];
      globalController.courseId.value = res["courseId"];
      activeName.value = res["name"];
      hasActive.value = true;
    }
    is_loading.value = false;


  }
}
