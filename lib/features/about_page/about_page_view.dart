import 'package:datamine/features/about_page/about_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class AboutPageView extends GetView<AboutPageController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "About Page",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage("assets/background/img_3.png"),
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.8),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                    child: Card(
                        elevation: 5,
                        margin: EdgeInsets.all(7),
                        color: Colors.black.withOpacity(0.001),
                        child: SizedBox(
                            height: 300,
                            width: 290,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .white, // White color for the border
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(
                                          12), // Border radius for rounded corners
                                      border: Border.all(
                                        color: Colors
                                            .white, // Color of the frame/border
                                        width: 2, // Thickness of the frame
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          8), // Inner image's border radius to match the frame
                                      child: Image.asset(
                                        "assets/icons/avatar.png",
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "DataMine",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )
                              ],
                            )))),
                SizedBox(
                  height: 30,
                ),
                Center(
                    child: Card(
                        elevation: 5,
                        margin: EdgeInsets.all(7),
                        color: Colors.black.withOpacity(0.001),
                        child: SizedBox(
                            height: 100,
                            width: 400,
                            child: Center(
                                child: Text(
                              "Made by :\nShivalik Sharma",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ))))),
                SizedBox(
                  height: 30,
                ),
                Center(
                    child: Card(
                        elevation: 5,
                        margin: EdgeInsets.all(7),
                        color: Colors.black.withOpacity(0.001),
                        child: SizedBox(
                            height: 100,
                            width: 400,
                            child: Center(
                                child: Text(
                              "Under Guidance of:\nDr. Punit Kumar Johari",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ))))),
      Center(
        child: Card(
          elevation: 5,
          margin: EdgeInsets.all(7),
          color: Colors.black.withOpacity(0.001),
          child: SizedBox(
            height: 100,
            width: 400,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "For Support Contact:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      controller.launchEmail(); // Call the function to open the email
                    },
                    child: Text(
                      "shivaliksharma2@gmail.com",
                      style: TextStyle(
                        color: Colors.blue, // Set email color to blue
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline, // Optionally underline the email
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )

      ],
            ),
          )
        ]));
  }
}
