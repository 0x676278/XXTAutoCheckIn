import 'package:get/get.dart';

import '../controllers/check_in_controller.dart';

class CheckInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckInController>(
      () => CheckInController(),
    );
  }
}
