import 'package:datamine/features/decision_tree/decision_tree_controller.dart';
import 'package:get/get.dart';

class DecisionTreeBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>DecisionTreeController());
  }

}