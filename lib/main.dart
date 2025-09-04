
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/global/GlobalController.dart';
import 'app/routes/app_pages.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/services/chaoxinApi.dart';
void main() {
  Get.put(GlobalController());
  Get.put(Chaoxinapi());
  runApp(
    ScreenUtilInit(
      designSize: const Size(1080, 2400),   //设计稿的宽度和高度 px
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return  GetMaterialApp(
          title: "Application",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      })
     
    
  );
}
