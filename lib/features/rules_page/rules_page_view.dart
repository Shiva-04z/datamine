import 'package:datamine/features/rules_page/rules_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class RulesPageView extends GetView<RulesPageController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Rules Page",style: TextStyle(color: Colors.white),),
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
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                    child: Text(
                  "Rules",
                  style: TextStyle(decoration: TextDecoration.underline ,
                    decorationColor: Colors.white,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 38,
                  ),
                  textAlign: TextAlign.center,
                )),
                SizedBox(
                  height: 20,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: '\u2022 ',
                          style:TextStyle(
                              color: Colors.white,
                              fontSize: 22)), // Unicode for bullet
                      TextSpan(
                          text: 'Dataset must be cleaned\n\n',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16)),
                      TextSpan(
                          text: '\u2022 ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22)),
                      TextSpan(
                          text: 'All values must be numeric.\n\n',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16)),
                      TextSpan(
                          text: '\u2022 ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22)),
                      TextSpan(
                          text: 'First Column should contain Target',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                    child: Text(
                  "Hints and Others",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 38,
                  ),
                  textAlign: TextAlign.center,
                )),
                SizedBox(
                  height: 30,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: '\u2022 ',
                          style: TextStyle(
                              color: Colors.white,
                             fontSize: 22)), // Unicode for bullet
                      TextSpan(
                          text:
                              'In classification it will say 0 as Foe and 1 as Friend\n\n',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16)),
                      TextSpan(
                          text: '\u2022 ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22)),
                      TextSpan(
                          text:
                              'If you got NaN it means the learning rate is not good',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16)),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
