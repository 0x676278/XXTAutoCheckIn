import 'package:get/get.dart';
import '../../../global/GlobalController.dart';
import '../../../moudel/courseModel.dart';
import '../../../services/chaoxinApi.dart';

class ClassController extends GetxController {
  var courseWrapper = CourseDataWrapper().obs; // 整个课程表对象
  final chaoxinapi = Get.find<Chaoxinapi>();
  final globalController = Get.find<GlobalController>();

  @override
  void onInit() async {
    super.onInit();
    await Future.delayed(Duration(milliseconds: 300)); // 延时 300ms
    await fetchCourseData();
    pageListener();
  }

  Future<void> fetchCourseData() async {
    final wrapper = await chaoxinapi.getClassTable();
    courseWrapper.value = wrapper;
    print(wrapper);
  }

  Future checkIfActive(var courseId, var classId) async {
    //print("courseId: $courseId");
    //print("classId: $classId");
    var activeList = await chaoxinapi.getSignTask(
      globalController.fid.value.toString(),
      courseId.toString(),
      classId.toString(),
    );
    print("正在进行的活动,${activeList}");
    if (activeList != null) {
      for (var active in activeList) {
        if (active["nameOne"] == "教务课程签到" && active["status"] == 1) {
            //await Get.snackbar("查询签到", "当前课程有可签到任务");
            //写入当前活动的activeId
            globalController.activeId.value = active["id"].toString();
            print("当前活动的activeId:${globalController.activeId.value}");
            //跳转到签到页面
            //Get.toNamed("/scan");
            //这里考虑到不可能同时有多个签到活动，所以直接返回
            return;
        } else {
          Get.snackbar("查询签到", "当前课程已结束");
          return;
        }
        print("签到任务名称：${active["name"]}");
      }
    }
    else {
      // 课程没有可签到任务
      print("课程没有可签到任务");
      Get.snackbar("查询签到：", "当前课程没有可签到任务");
    }
  }


  /**
   * 页面监听器
   */
  void pageListener() async {
    // 监听 count 的变化
    ever(globalController.index, (value) async{
      if (value == 0) {
        print("正在刷新");
        await fetchCourseData();
      }
    });
  }
}
