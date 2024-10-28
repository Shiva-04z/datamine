import 'package:datamine/features/polynoimal_regression/polynomial_controller.dart';
import 'package:get/get.dart';



class PolynomialRegressionBindings extends Bindings
{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>PolynomialRegressionController());
  }

}