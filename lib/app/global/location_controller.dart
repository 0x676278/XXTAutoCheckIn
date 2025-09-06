import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  // 当前经纬度
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    //getLocation();
    //默认位置
    latitude.value=-1;
    longitude.value=-1;
  }

  Future<void> getLocation() async {
    print("获取位置");
   isLoading.value = true;
    bool serviceEnabled;
    LocationPermission permission;

    // 检查定位服务是否开启
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('错误', '请开启定位服务');
      isLoading.value = false;
      return;
    }

    // 检查权限
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('错误', '定位权限被拒绝');
        isLoading.value = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('错误', '定位权限被永久拒绝，请在设置中开启');
      isLoading.value = false;
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          forceAndroidLocationManager: true); // 强制使用原生 LocationManager);

      latitude.value = double.parse(position.latitude.toStringAsFixed(6));
      longitude.value = double.parse(position.longitude.toStringAsFixed(6));

    } catch (e) {
      Get.snackbar('错误', '获取定位失败: $e');
    } finally {
      isLoading.value = false;
    }
    isLoading.value = false;
  }
}
