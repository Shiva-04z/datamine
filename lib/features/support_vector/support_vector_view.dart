import 'package:datamine/features/support_vector/support_vector_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SVMTrainingView extends GetView<SVMController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "SVM Classifier",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(children: [
        const SizedBox(
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
                  const Text(
                    "Guardian Training",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Prepare your Guardian (SVM) to distinguish between two types of data warriors. Enter the training parameters below:",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: controller.epochsController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        label: Text(
                          "Number of Training Rounds (Epochs)",
                        ),),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: controller.learningRateController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      label: Text(
                        "Guardian’s Learning Speed (Learning Rate)",

                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: controller.lambdaController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      label: Text(
                          "Guardian's Discipline (Regularization - Lambda)",
                          ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.trainModel();
                      },
                      child: const Text("Start Guardian Training"),
                    ),
                  ),
                  if (controller.isTraining.value)
                    const Column(
                      children: [
                        SizedBox(height: 20),
                        Center(child: CircularProgressIndicator(strokeWidth: 5,color: Colors.white,)),
                        SizedBox(height: 20),
                        Text(
                          "Your Guardian is learning...",
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  if (controller.trainingMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(controller.trainingMessage.value,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  const SizedBox(height: 20),
                  if (!controller.isTraining.value &&
                      controller.trainingMessage.isNotEmpty)
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _showPredictionDialog(context);
                        },
                        child: const Text("Use Guardian for Prediction"),
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
                const Text(
                  "Enter the details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  width: 250,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0;
                              i < controller.featureControllers.length;
                              i++) ...[
                            TextField(
                              controller: controller.featureControllers[i],
                              decoration: InputDecoration(
                                labelText: "${controller.featureNames[i]}",
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 0.2),
                                ), // Dynamic feature name
                              ),
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
