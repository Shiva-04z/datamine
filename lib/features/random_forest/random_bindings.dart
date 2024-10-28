import 'package:datamine/features/random_forest/random_controller.dart';
import 'package:get/get.dart';

class RandomBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>RandomForestController());
  }

}