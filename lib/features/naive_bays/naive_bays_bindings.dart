import 'package:datamine/features/naive_bays/naive_bays_controller.dart';
import 'package:get/get.dart';

class NaiveBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>NaiveBayesController());
  }

}