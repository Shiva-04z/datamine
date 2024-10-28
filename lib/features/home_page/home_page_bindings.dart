import 'package:get/get.dart';
import 'home_page_controller.dart';

class HomePageBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>HomePageController());
  }
}
