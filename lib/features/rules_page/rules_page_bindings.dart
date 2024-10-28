import 'package:datamine/features/rules_page/rules_page_controller.dart';
import 'package:get/get.dart';

class RulesPageBindings extends Bindings
{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>RulesPageController());
  }

}