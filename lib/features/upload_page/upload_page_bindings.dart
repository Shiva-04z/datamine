import 'package:datamine/features/upload_page/upload_page_controller.dart';
import 'package:get/get.dart';

class UploadPageBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>UploadPageController());
  }

}