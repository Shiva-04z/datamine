import 'package:datamine/features/selectalgoritm/select_algo_controller.dart';
import 'package:get/get.dart';

class SelectAlgoBindings extends Bindings
{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>SelectAlgoController());
  }

}