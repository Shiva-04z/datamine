import 'package:datamine/features/lasso/lasso_controller.dart';
import 'package:get/get.dart';
class LassoRegressionBindings extends Bindings
{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>LassoRegressionController());
  }

}