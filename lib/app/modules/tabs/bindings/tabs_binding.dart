import 'package:get/get.dart';

import '../../../global/GlobalController.dart';
import '../../../services/chaoxinApi.dart';
import '../../check_in/controllers/check_in_controller.dart';
import '../../class/controllers/class_controller.dart';
import '../controllers/tabs_controller.dart';
import '../../user/controllers/user_controller.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabsController>(
      () => TabsController(),
    );
    Get.lazyPut<UserController>(
      () => UserController(),
    );
    Get.lazyPut<ClassController>(
          () => ClassController(),
    );
    Get.lazyPut<CheckInController>(
          () => CheckInController(),
    );
    Get.lazyPut<GlobalController>(
          () => GlobalController(),
    );
    Get.lazyPut<Chaoxinapi>(
          () => Chaoxinapi(),
    );
  }
}
