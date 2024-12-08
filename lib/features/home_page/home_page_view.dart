import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'home_page_controller.dart';

class HomePageView extends GetView<HomePageController> {
  Widget card1(String name, String description, String image) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.1),
      child: Container(
        height: 140,
        width: 180,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  image: AssetImage(image),
                  height: 50,
                  width: 50,
                ),
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Screen width and height to adjust layout
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800; // Switch layout on larger screens

    return Scaffold(
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            "assets/background/img.png",
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black.withOpacity(0.6),
        ),
        SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: isDesktop ? 40 : 30),
                Text(
                  "Welcome",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: isDesktop ? 32 : 28,
                  ),
                ),
                SizedBox(height: isDesktop ? 40 : 30),
                Container(
                  height: isDesktop ? 600: 300,
                  width: isDesktop? 700: double.infinity,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: isDesktop ? 700: 300, // Adjust carousel height
                      autoPlay: true,

                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      onPageChanged: (index, reason) {
                        controller.activeIndex.value = index;
                      },
                    ),
                    items: controller.imgList.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                            ),
                            child: Image.asset(item, fit: BoxFit.cover),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10),
                Obx(() => AnimatedSmoothIndicator(
                  activeIndex: controller.activeIndex.value,
                  count: controller.imgList.length,
                  effect: WormEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey.shade400,
                  ),
                )),
                SizedBox(height: 20),
                Text(
                  "Explore our features!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 26 : 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // Wrap instead of Row for adaptive layout
                isDesktop? Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    InkWell(
                      child: card1("UPLOAD", "Upload a new Dataset",
                          "assets/icons/upload.png"),
                      onTap: () => controller.toUpload(),
                    ),
                    InkWell(
                      child: card1("SELECT", "Select an existing Dataset",
                          "assets/icons/selection.png"),
                      onTap: () => controller.toSelection(),
                    ),
                    InkWell(
                      child: card1("Rules", "View the DataSet Rules",
                          "assets/icons/history.png"),
                      onTap: () => controller.toRules(),
                    ),
                    InkWell(
                      child: card1("ABOUT", "Know about developer",
                          "assets/icons/about.png"),
                      onTap: () => controller.toAbout(),
                    ),
                  ],
                ): Column( mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center
                  ,children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [ InkWell(
                    child: card1("UPLOAD", "Upload a new Dataset",
                        "assets/icons/upload.png"),
                    onTap: () => controller.toUpload(),
                  ),
                    InkWell(
                      child: card1("SELECT", "Select an existing Dataset",
                          "assets/icons/selection.png"),
                      onTap: () => controller.toSelection(),
                    ),],),
                 SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [InkWell(
                      child: card1("Rules", "View the DataSet Rules",
                          "assets/icons/history.png"),
                      onTap: () => controller.toRules(),
                    ),
                      InkWell(
                        child: card1("ABOUT", "Know about developer",
                            "assets/icons/about.png"),
                        onTap: () => controller.toAbout(),
                      ),],
                  )

                ],),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
