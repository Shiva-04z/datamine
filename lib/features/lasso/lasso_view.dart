import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'lasso_controller.dart';


class LassoRegressionTrainingView extends GetView<LassoRegressionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("LASSO Regression Training",style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.black.withOpacity(0.3),
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Train LASSO Regression Model",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.epochsController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: "Number of Epochs",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 30),
              TextField(
                controller: controller.learningRateController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: "Learning Rate",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 30),
              TextField(
                controller: controller.lambdaController, // New field for LASSO
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: "Lambda (Regularization Strength)",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    controller.trainModel();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  child: Text(
                    "Train Model",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (controller.isTraining.value)  Center(child: CircularProgressIndicator(strokeWidth: 5,color: Colors.white,)),
              if (controller.trainingMessage.isNotEmpty)
                Text(
                  controller.trainingMessage.value,
                  style: TextStyle(color: Colors.white),
                ),
              SizedBox(height: 20),
              if (!controller.isTraining.value &&
                  controller.trainingMessage.isNotEmpty)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _showPredictionDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: Text(
                      "Predict with Trained Model",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          )),
        ),
      ]),
    );
  }

  void _showPredictionDialog(BuildContext context) {
    Get.defaultDialog(
      backgroundColor: Colors.white.withOpacity(0.8),
      title: "Make a Prediction",
      content: SingleChildScrollView(
        child: Wrap(
          children: [
            Column(
              children: [
                Text(
                  "Enter the details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  width: 250,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < controller.featureControllers.length; i++) ...[
                            TextField(
                              controller: controller.featureControllers[i],
                              decoration: InputDecoration(
                                  labelText: "${controller.featureNames[i]}",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black, width: 0.2))),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 15),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    controller.predict();
                  },
                  child: Text("Predict"),
                ),
                Obx(() => controller.predictionResult.isNotEmpty
                    ? Text("Prediction: ${controller.predictionResult.value}")
                    : Container()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
