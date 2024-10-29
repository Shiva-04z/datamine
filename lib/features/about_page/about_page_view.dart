import 'package:datamine/features/about_page/about_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class AboutPageView extends GetView<AboutPageController>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,
        title: Text("About Page",style: TextStyle(color: Colors.white),),),

    );
  }
}
