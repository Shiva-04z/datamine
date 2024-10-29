import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:datamine/core/globals.dart' as glb;
import 'model/random.dart'; // Import your Random Forest model

class RandomForestController extends GetxController {
  var nTreesController = TextEditingController();
  var maxDepthController = TextEditingController();
  var minSamplesSplitController = TextEditingController();
  var isTraining = false.obs;
  var trainingMessage = ''.obs;
  var predictionResult = ''.obs;

  List<TextEditingController> featureControllers = [];
  List<String> featureNames = []; // List to store feature names
  RandomForestModel? trainedModel; // Random Forest model instance

  @override
  void onClose() {
    // Dispose of controllers to free resources
    nTreesController.dispose();
    maxDepthController.dispose();
    minSamplesSplitController.dispose();
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
      // Parse parameters from input controllers
      int nTrees = int.parse(nTreesController.text);
      int maxDepth = int.parse(maxDepthController.text);
      int minSamplesSplit = int.parse(minSamplesSplitController.text);

      // Download and prepare the dataset from CSV
      final csvUrl = glb.fileUrl.value;
      final csvData = await downloadAndPrepareCSV(csvUrl);

      // Check if CSV data is valid
      if (csvData.isEmpty) {
        trainingMessage.value = "CSV data is empty or invalid.";
        return;
      }

      // Set feature names from the first row of the CSV
      featureNames = List<String>.from(csvData[0].sublist(1));

      // Train the Random Forest model and calculate accuracy
      double accuracy = await trainRandomForestModel(csvData, nTrees, maxDepth, minSamplesSplit);
      trainingMessage.value = "Model trained successfully with $nTrees trees, max depth of $maxDepth, "
          "and minimum samples to split of $minSamplesSplit.\nAccuracy: ${accuracy.toStringAsFixed(2)}%";
    } catch (e) {
      // Handle any errors during training
      trainingMessage.value = "Error during training: ${e.toString()}";
      print("Training error: $e");
    } finally {
      isTraining.value = false;
    }
  }

  Future<double> trainRandomForestModel(List<List<dynamic>> data, int nTrees, int maxDepth, int minSamplesSplit) async {
    List<double> target = [];
    List<List<double>> features = [];

    if (data.isEmpty || data.length < 2) {
      trainingMessage.value = "No valid data for training.";
      return 0.0;
    }

    for (var row in data.sublist(1)) {
      if (row.length < 2) {
        print("Invalid row length, skipping row: $row");
        continue;
      }

      try {
        target.add((row[0] as num).toDouble());
        List<double> featureRow = row.sublist(1).map((e) => (e as num).toDouble()).toList();
        features.add(featureRow);
      } catch (e) {
        print("Error parsing row: $row, error: $e");
      }
    }

    if (target.isEmpty || features.isEmpty) {
      trainingMessage.value = "No valid data for training.";
      return 0.0;
    }

    // Initialize and fit the Random Forest model
    trainedModel = RandomForestModel(nTrees: nTrees, maxDepth: maxDepth, minSamplesSplit: minSamplesSplit);
    await trainedModel!.fit(features, target);

    // Prepare input controllers for features
    featureControllers = List.generate(features[0].length, (_) => TextEditingController());

    // Calculate accuracy
    double accuracy = calculateAccuracy(features, target);
    print("Model training completed. Accuracy: $accuracy%");
    return accuracy;
  }

  double calculateAccuracy(List<List<double>> features, List<double> target) {
    int correctPredictions = 0;

    // Make predictions for the training data
    List<int> predictions = trainedModel!.predict(features);

    // Compare predictions with actual target values
    for (int i = 0; i < predictions.length; i++) {
      if (predictions[i].toDouble() == target[i]) {
        correctPredictions++;
      }
    }

    // Calculate accuracy as a percentage
    return (correctPredictions / target.length) * 100;
  }

  Future<List<List<dynamic>>> downloadAndPrepareCSV(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse CSV data
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

    // Prepare features for prediction
    List<double> features = featureControllers
        .map((controller) => double.tryParse(controller.text) ?? 0.0)
        .toList();

    List<int> prediction = trainedModel!.predict([features]);

    if(prediction[0]==0.0){
      predictionResult.value = "Foe";}else  if(prediction[0]==1.0){
      predictionResult.value = "Friend";}
  }
}
