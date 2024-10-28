import 'package:datamine/features/support_vector/support_vector_controller.dart';
import 'package:get/get.dart';

class SVMBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>SVMController());
  }

}