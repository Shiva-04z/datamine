import 'package:datamine/features/about_page/about_page_controller.dart';
import 'package:get/get.dart';

class AboutPageBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>AboutPageController());
  }

}