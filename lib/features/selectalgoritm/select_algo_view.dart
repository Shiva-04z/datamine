import 'package:datamine/features/selectalgoritm/select_algo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datamine/core/globals.dart' as glb; // Import your globals


import '../../navigation/routes_constant.dart'; // Import your routes constant

class SelectAlgoView extends GetView<SelectAlgoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Algorithm",),
      ),
      body: Stack(
        children: [
          const SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage("assets/background/img_1.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.1),
          ),
          Obx(() => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Selected Dataset:  ${controller.name} by ${controller.authorName}",
                    style: const TextStyle(color: Colors.white,fontSize: 18),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Choose one of the Following Algorithms",
                    style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: ListView.builder(
                      itemCount: controller.algorithms.length,  // Dynamic count
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Card(
                            elevation: 5,
                            child: Container(
                              color: Colors.black.withOpacity(0.6),
                              height: 40,
                              child: Center(
                                child: Text(
                                  controller.algorithms[index],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            // Store the selected algorithm in glb.selectedAlgo.value
                            glb.selectedAlgo.value = controller.algorithms[index];
                            Get.snackbar("Algorithm Selected", "You selected: ${controller.algorithms[index]}");

                            // Navigate to Linear Regression Training View if selected algo is Linear Regression
                            if (controller.algorithms[index] == "Linear Regression") {

                              Get.offNamed(RoutesConstant.linear);
                            }
                            else if (controller.algorithms[index] == "Lasso") {

                              Get.offNamed(RoutesConstant.lasso);
                            }
                            else  if (controller.algorithms[index] == "Ridge") {

                              Get.offNamed(RoutesConstant.ridge);
                            }
                            else  if (controller.algorithms[index] == "Polynomial Regression") {

                              Get.offNamed(RoutesConstant.polynomial);
                            }
                            else  if (controller.algorithms[index] == "Decision Tree") {

                              Get.offNamed(RoutesConstant.decisiontree);
                            }
                            else  if (controller.algorithms[index] == "SVM") {

                              Get.offNamed(RoutesConstant.svm);
                            } else  if (controller.algorithms[index] == "Random Forest") {

                              Get.offNamed(RoutesConstant.random);
                            } else  if (controller.algorithms[index] == "Naive Bayes") {

                              Get.offNamed(RoutesConstant.naive);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
