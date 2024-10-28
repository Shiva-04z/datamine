import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'home_page_controller.dart'; // Import for the AnimatedSmoothIndicator

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
              image: AssetImage("$image"),
              height: 50,
              width: 50,
            ),
            Text(
              "$name",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            Text(
              "$description",
              style: TextStyle(color: Colors.white),
            ),
          ],
        )),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image(
            image: AssetImage("assets/background/img.png"),
            fit: BoxFit.fill,
          ),
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black.withOpacity(0.6),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                "Welcome",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 28),
              ),
              SizedBox(height: 30),
              // CarouselSlider with onPageChanged to update activeIndex
              CarouselSlider(
                options: CarouselOptions(
                  height: 325.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  onPageChanged: (index, reason) {
                    controller.activeIndex.value =
                        index; // Update active index in controller
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

              SizedBox(height: 10),

              // Smooth Page Indicator below the Carousel
              Obx(() => AnimatedSmoothIndicator(
                    activeIndex: controller
                        .activeIndex.value, // Uses activeIndex from controller
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: card1("UPLOAD", "Upload a new Dataset",
                        "assets/icons/upload.png"),
                    onTap:()=> controller.toUpload(),
                  ),
                  InkWell(
                    child: card1("SELECT", "Select an existing Dataset",
                        "assets/icons/selection.png"),
                    onTap:()=> controller.toSelection(),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: card1("Rules", "View the DataSet Rules",
                        "assets/icons/selection.png"),
                    onTap: ()=>controller.toRules(),
                  ),
                  InkWell(
                      child: card1("ABOUT", "Know about developer",
                          "assets/icons/about.png"),
                      onTap: ()=>controller.toAbout())
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
