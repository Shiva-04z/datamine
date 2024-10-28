import 'package:datamine/features/selection_page/selection_page_controller.dart';
import 'package:get/get.dart';

class SelectionPageBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>SelectionPageController());
  }

}