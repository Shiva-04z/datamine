import 'package:datamine/navigation/routes_constant.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  RxInt activeIndex = 0.obs;
  final List<String> imgList = [
    "assets/tutorial/tutorial_1.png",
    "assets/tutorial/tutorial_2.png",
    "assets/tutorial/tutorial_3.png",
    "assets/tutorial/tutorial_4.png",
  ];
  toAbout() {
    Get.toNamed(RoutesConstant.about);
  }

  toUpload() {
    Get.toNamed(RoutesConstant.upload);
  }

  toSelection() {
    Get.toNamed(RoutesConstant.selection);
  }

  toRules() {
    Get.toNamed(RoutesConstant.rules);
  }
}
