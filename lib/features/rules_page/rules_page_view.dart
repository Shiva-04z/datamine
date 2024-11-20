import 'package:datamine/features/rules_page/rules_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class RulesPageView extends GetView<RulesPageController> {
  @override
  Widget build(BuildContext context) {
    // Determine if the device is a desktop or mobile based on width
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Rules Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image(
            image: AssetImage("assets/background/img_2.png"),
            fit: BoxFit.fill,
          ),
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black.withOpacity(0.8),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left:isDesktop ? 100 : 12,right:isDesktop ? 100 : 12,top:12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isDesktop ? 50 : 30),
                Center(
                  child: Text(
                    "Rules",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isDesktop ? 42 : 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: isDesktop ? 30 : 20),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: '\u2022 ',
                          style: TextStyle(
                              color: Colors.white, fontSize: 22)),
                      TextSpan(
                          text: 'Dataset must be cleaned\n\n',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 18 : 16)),
                      TextSpan(
                          text: '\u2022 ',
                          style: TextStyle(
                              color: Colors.white, fontSize: 22)),
                      TextSpan(
                          text: 'All values must be numeric.\n\n',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 18 : 16)),
                      TextSpan(
                          text: '\u2022 ',
                          style: TextStyle(
                              color: Colors.white, fontSize: 22)),
                      TextSpan(
                          text: 'First Column should contain Target',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 18 : 16)),
                    ],
                  ),
                ),
                SizedBox(height: isDesktop ? 40 : 30),
                Center(
                  child: Text(
                    "Hints and Others",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isDesktop ? 42 : 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: isDesktop ? 30 : 20),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: '\u2022 ',
                          style: TextStyle(
                              color: Colors.white, fontSize: 22)),
                      TextSpan(
                          text:
                          'In classification, 0 represents Foe and 1 represents Friend\n\n',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 18 : 16)),
                      TextSpan(
                          text: '\u2022 ',
                          style: TextStyle(
                              color: Colors.white, fontSize: 22)),
                      TextSpan(
                          text:
                          'If you encounter NaN, it may indicate a problematic learning rate',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 18 : 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
