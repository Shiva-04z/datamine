import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:datamine/core/globals.dart' as glb;
import 'package:csv/csv.dart';
import 'dart:convert';
import 'model/ridge.dart'; // Import your Ridge regression model

class RidgeRegressionController extends GetxController {
  var epochsController = TextEditingController();
  var learningRateController = TextEditingController();
  var lambdaController = TextEditingController(); // L2 Regularization (Lambda) controller
  var isTraining = false.obs;
  var trainingMessage = ''.obs;
  var predictionResult = ''.obs;
  var mapeResult = ''.obs; // Observable to store the MAPE result

  List<TextEditingController> featureControllers = [];
  List<String> featureNames = []; // List to store feature names
  RidgeRegressionModel? trainedModel;

  RidgeRegressionController();

  @override
  void onInit() {
    // Initialize the model within the controller with lambda = 0 initially
    trainedModel = RidgeRegressionModel(lambda: 0.0);
    super.onInit();
  }

  @override
  void onClose() {
    epochsController.dispose();
    learningRateController.dispose();
    lambdaController.dispose(); // Dispose of lambda controller
    for (var controller in featureControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> trainModel() async {
    isTraining.value = true;
    trainingMessage.value = "";
    predictionResult.value = "";
    mapeResult.value = ""; // Clear MAPE result

    try {
      // Get user input
      int epochs = int.parse(epochsController.text);
      double learningRate = double.parse(learningRateController.text);
      double lambda = double.parse(lambdaController.text); // Get lambda value

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

      // Update the lambda in the model
      trainedModel?.setLambda(lambda);

      // Train the Ridge regression model
      await trainRidgeRegressionModel(csvData, epochs, learningRate, lambda);
      double mape = calculateMAPEForTraining(csvData);
      trainingMessage.value = "Ridge model trained successfully.\nMean Absolute Percentage Error :${mape.toStringAsFixed(2)}%";
    } catch (e) {
      trainingMessage.value = "Error during training: ${e.toString()}";
      print("Training error: $e"); // Added error print for debugging
    } finally {
      isTraining.value = false;
    }
  }

  Future<void> trainRidgeRegressionModel(List<List<dynamic>> data, int epochs, double learningRate, double lambda) async {
    List<double> target = [];
    List<List<double>> features = [];

    if (data.isEmpty || data.length < 2) {
      print("Insufficient data for training.");
      trainingMessage.value = "No valid data for training.";
      return;
    }

    for (var row in data.sublist(1)) { // Skip header
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
      print("No valid data for training after parsing.");
      trainingMessage.value = "No valid data for training.";
      return;
    }

    await trainedModel?.fit(features, target, epochs: epochs, learningRate: learningRate);
    featureControllers = List.generate(features[0].length, (_) => TextEditingController());
    print("Ridge model training completed.");
  }

  Future<void> predict() async {
    if (trainedModel == null) {
      predictionResult.value = "Model is not trained.";
      print("Prediction error: Model not trained.");
      return;
    }

    List<double> features = featureControllers.map((controller) => double.tryParse(controller.text) ?? 0.0).toList();
    List<double> prediction = trainedModel!.predict([features]);

    predictionResult.value = "Predicted Value: ${prediction[0].toStringAsFixed(2)}";
    print("Prediction Result: ${prediction[0]}");
  }

  Future<List<List<dynamic>>> downloadAndPrepareCSV(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<List<dynamic>> csvData = const CsvToListConverter().convert(response.body);
      Get.snackbar("CSV Loaded", "Data Set Ready");
      return csvData;
    } else {
      throw Exception("Failed to load CSV data");
    }
  }

  // Calculate MAPE using the training data
  double calculateMAPEForTraining(List<List<dynamic>> data) {
    if (trainedModel == null) return double.nan;

    List<double> target = [];
    List<List<double>> features = [];

    for (var row in data.sublist(1)) {
      if (row.length < 2) continue;

      target.add((row[0] as num).toDouble());
      List<double> featureRow = row.sublist(1).map((e) => (e as num).toDouble()).toList();
      features.add(featureRow);
    }

    List<double> predictions = trainedModel!.predict(features);
    return trainedModel!.calculateMAPE(predictions, target);
  }
}
