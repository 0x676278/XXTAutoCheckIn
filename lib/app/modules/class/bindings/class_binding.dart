import 'package:get/get.dart';

import '../controllers/class_controller.dart';

class ClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassController>(
      () => ClassController(),
    );
  }
}
