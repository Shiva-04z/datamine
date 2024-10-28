import 'package:datamine/features/ridge/ridge_controller.dart';
import 'package:get/get.dart';

class RidgeBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>RidgeRegressionController());
  }

}