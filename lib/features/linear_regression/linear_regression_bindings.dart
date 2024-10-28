import 'package:get/get.dart';

import 'linear_regression_controller.dart';

class LinearRegressionBindings extends Bindings
{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>LinearRegressionController());
  }

}