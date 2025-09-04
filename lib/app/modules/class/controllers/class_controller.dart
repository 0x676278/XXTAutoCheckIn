
import 'package:get/get.dart';
import '../../../moudel/courseModel.dart';
import '../../../services/chaoxinApi.dart';



class ClassController extends GetxController {
  var courseWrapper = CourseDataWrapper().obs; // 整个课程表对象
  final chaoxinapi = Get.find<Chaoxinapi>();

  @override
  void onInit() async{
    super.onInit();
    await Future.delayed(Duration(milliseconds: 300)); // 延时 300ms
    fetchCourseData();
  }

  void fetchCourseData() async {
      final wrapper = await chaoxinapi.getClassTable();
      courseWrapper.value = wrapper;
      print(wrapper);

}}
