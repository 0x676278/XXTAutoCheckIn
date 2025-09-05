import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global/GlobalController.dart';
import '../../check_in/views/check_in_view.dart';
import '../../class/views/class_view.dart';
import '../../user/views/user_view.dart';

class TabsController extends GetxController {
  RxInt currentIndex = 0.obs;
  PageController pageController=PageController(initialPage:0);
  final GlobalController globalController = Get.find();
  final List<Widget> pages = const [

    ClassView(),
    CheckInView(),
    UserView()
  ];
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setCurrentIndex(index) {
    currentIndex.value = index;
    globalController.tabChanged(index);
    update();
  }
}
