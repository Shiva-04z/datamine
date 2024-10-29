import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:datamine/core/globals.dart' as glb;
import 'model/decision_tree.dart'; // Your decision tree model import

class DecisionTreeController extends GetxController {
  var maxDepthController = TextEditingController();
  var isTraining = false.obs;
  var trainingMessage = ''.obs;
  var predictionResult = ''.obs;

  List<TextEditingController> featureControllers = [];
  List<String> featureNames = []; // List to store feature names
  DecisionTreeClassifier? trainedModel;

  @override
  void onClose() {
    maxDepthController.dispose();
    for (var controller in featureControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> trainModel() async {
    isTraining.value = true;
    trainingMessage.value = "";
    predictionResult.value = "";

    try {
      // Get user input
      int maxDepth = int.parse(maxDepthController.text);

      // Download and prepare the dataset from CSV
      final csvUrl = glb.fileUrl.value;
      final csvData = await downloadAndPrepareCSV(csvUrl);

      if (csvData.isEmpty) {
        trainingMessage.value = "CSV data is empty or invalid.";
        isTraining.value = false;
        return;
      }

      // Set feature names from the first row of the CSV
      featureNames = List<String>.from(csvData[0].sublist(1)); // Assuming first row is headers

      // Prepare data for training
      List<int> target = [];
      List<List<double>> features = [];

      for (var row in csvData.sublist(1)) { // Skip header
        if (row.length < 2) continue; // Skip rows with insufficient columns
        target.add((row[0] as num).toInt()); // Assuming target is in the first column
        features.add(row.sublist(1).map((e) => (e as num).toDouble()).toList());
      }

      // Train the decision tree model
      await trainDecisionTreeModel(features, target, maxDepth);

      // Calculate accuracy
      double accuracy = _calculateAccuracy(features, target);
      trainingMessage.value =
      "Model trained successfully with max depth of $maxDepth.\nAccuracy: ${accuracy.toStringAsFixed(2)}%";
    } catch (e) {
      trainingMessage.value = "Error during training: ${e.toString()}";
      print("Training error: $e");
    } finally {
      isTraining.value = false;
    }
  }

  Future<void> trainDecisionTreeModel(List<List<double>> features, List<int> target, int maxDepth) async {
    // Initialize and fit the decision tree model
    trainedModel = DecisionTreeClassifier();
    await trainedModel!.fit(features, target, maxDepth: maxDepth);

    // Create text controllers for each feature (based on the number of features in the dataset)
    featureControllers = List.generate(features[0].length, (_) => TextEditingController());
    print("Model training completed.");
  }

  Future<List<List<dynamic>>> downloadAndPrepareCSV(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Decode the CSV content
      final List<List<dynamic>> csvData = const CsvToListConverter().convert(response.body);
      Get.snackbar("CSV Loaded", "Data Set Ready");
      return csvData;
    } else {
      throw Exception("Failed to load CSV data");
    }
  }

  Future<void> predict() async {
    if (trainedModel == null) {
      predictionResult.value = "Model is not trained.";
      print("Prediction error: Model not trained.");
      return;
    }

    // Collect the features from the user input
    List<double> features = featureControllers
        .map((controller) => double.tryParse(controller.text) ?? 0.0)
        .toList();

    // Use the trained model to predict
    List<int> prediction = trainedModel!.predict([features]);

    // Display the result
    if(prediction[0]==0.0){
      predictionResult.value = "Foe";}else  if(prediction[0]==1.0){
      predictionResult.value = "Friend";}
  }

  double _calculateAccuracy(List<List<double>> features, List<int> target) {
    List<int> predictions = trainedModel!.predict(features);
    int correctPredictions = 0;

    for (int i = 0; i < target.length; i++) {
      if (predictions[i] == target[i]) {
        correctPredictions++;
      }
    }

    return (correctPredictions / target.length) * 100;
  }
}
