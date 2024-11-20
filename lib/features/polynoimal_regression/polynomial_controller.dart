import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:datamine/core/globals.dart' as glb;
import 'model/polynomial.dart'; // Your polynomial regression model import

class PolynomialRegressionController extends GetxController {
  var epochsController = TextEditingController();
  var learningRateController = TextEditingController();
  var degreeController = TextEditingController();
  var isTraining = false.obs;
  var trainingMessage = ''.obs;
  var predictionResult = ''.obs;
  var mapeResult = ''.obs;
  List<TextEditingController> featureControllers = [];
  List<String> featureNames = [];
  PolynomialRegressionModel? trainedModel;

  @override
  void onClose() {
    epochsController.dispose();
    learningRateController.dispose();
    degreeController.dispose();
    for (var controller in featureControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> trainModel() async {
    isTraining.value = true;
    trainingMessage.value = "";
    predictionResult.value = "";
    mapeResult.value = "";

    try {
      // Get user input
      int epochs = int.parse(epochsController.text);
      double learningRate = double.parse(learningRateController.text);
      int degree = int.parse(degreeController.text);

      // Download and prepare the dataset from CSV
      final csvUrl = glb.fileUrl.value;
      final csvData = await downloadAndPrepareCSV(csvUrl);

      if (csvData.isEmpty) {
        trainingMessage.value = "CSV data is empty or invalid.";
        isTraining.value = false;
        return;
      }


      await trainPolynomialRegressionModel(csvData, epochs, learningRate, degree);

      double mape = _calculateMAPE(csvData);
      mapeResult.value = "MAPE: ${mape.toStringAsFixed(2)}%";
      trainingMessage.value = "Model trained successfully with $epochs epochs, learning rate of $learningRate, and polynomial degree of $degree.\n$mapeResult";
    } catch (e) {
      trainingMessage.value = "Error during training: ${e.toString()}";
    } finally {
      isTraining.value = false;
    }
  }

  Future<void> trainPolynomialRegressionModel(List<List<dynamic>> data, int epochs, double learningRate, int degree) async {
    List<double> target = [];
    List<List<double>> features = [];

    // Check if data has enough rows
    if (data.isEmpty || data.length < 2) {
      trainingMessage.value = "No valid data for training.";
      return;
    }

    for (var row in data.sublist(1)) {
      if (row.length < 2) {

        continue;
      }

      try {
        target.add((row[0] as num).toDouble());
        List<double> featureRow = row.sublist(1).map((e) => (e as num).toDouble()).toList();
        features.add(featureRow);
      } catch (e) {
      }
    }

    if (target.isEmpty || features.isEmpty) {

      trainingMessage.value = "No valid data for training.";
      return;
    }


    // Initialize and fit the polynomial regression model
    trainedModel = PolynomialRegressionModel(degree: degree);
    await trainedModel!.fit(features, target, epochs: epochs, learningRate: learningRate);

    // Create text controllers for each feature (based on the number of features in the dataset)
    featureControllers = List.generate(features[0].length, (_) => TextEditingController());
  }

  double _calculateMAPE(List<List<dynamic>> data) {
    List<double> target = [];
    List<List<double>> features = [];

    for (var row in data.sublist(1)) { // Skip header
      try {
        target.add((row[0] as num).toDouble());
        List<double> featureRow = row.sublist(1).map((e) => (e as num).toDouble()).toList();
        features.add(featureRow);
      } catch (e) {
        print("Error parsing row for MAPE: $row, error: $e");
      }
    }

    if (target.isEmpty || features.isEmpty || trainedModel == null) {
      return 0.0; // Return 0 if no valid data
    }

    List<double> predictions = trainedModel!.predict(features);
    double mape = 0.0;

    for (int i = 0; i < predictions.length; i++) {
      if (target[i] != 0) {
        mape += (predictions[i] - target[i]).abs() / target[i]; // Absolute percentage error
      }
    }

    return (mape / predictions.length) * 100; // Mean percentage error
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
  Future<void> predict() async {
    if (trainedModel == null) {
      predictionResult.value = "Model is not trained.";
      return;
    }
    List<double> features = featureControllers
        .map((controller) => double.tryParse(controller.text) ?? 0.0)
        .toList();

    List<double> prediction = trainedModel!.predict([features]);
    predictionResult.value = "Predicted Value: ${prediction[0].toStringAsFixed(2)}";
  }
}
