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
  var mapeResult = ''.obs; // To store MAPE result

  List<TextEditingController> featureControllers = [];
  List<String> featureNames = []; // List to store feature names
  PolynomialRegressionModel? trainedModel; // Polynomial model instance

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
    mapeResult.value = ""; // Reset MAPE result

    try {
      // Get user input
      int epochs = int.parse(epochsController.text);
      double learningRate = double.parse(learningRateController.text);
      int degree = int.parse(degreeController.text); // Degree for polynomial regression

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

      // Train the polynomial regression model
      await trainPolynomialRegressionModel(csvData, epochs, learningRate, degree);

      // Calculate and display MAPE after training
      double mape = _calculateMAPE(csvData);
      mapeResult.value = "MAPE: ${mape.toStringAsFixed(2)}%";

      trainingMessage.value = "Model trained successfully with $epochs epochs, learning rate of $learningRate, and polynomial degree of $degree.\n$mapeResult";
    } catch (e) {
      trainingMessage.value = "Error during training: ${e.toString()}";
      print("Training error: $e");
    } finally {
      isTraining.value = false;
    }
  }

  Future<void> trainPolynomialRegressionModel(List<List<dynamic>> data, int epochs, double learningRate, int degree) async {
    List<double> target = [];
    List<List<double>> features = [];

    // Check if data has enough rows
    if (data.isEmpty || data.length < 2) {
      print("Insufficient data for training.");
      trainingMessage.value = "No valid data for training.";
      return;
    }

    for (var row in data.sublist(1)) { // Skip header
      // Ensure the row has the required number of columns
      if (row.length < 2) {
        print("Invalid row length, skipping row: $row");
        continue;
      }

      try {
        // Target is the first column (cast it to a double)
        target.add((row[0] as num).toDouble());

        // Features are the remaining columns (cast to double)
        List<double> featureRow = row.sublist(1).map((e) => (e as num).toDouble()).toList();
        features.add(featureRow);
      } catch (e) {
        print("Error parsing row: $row, error: $e");
      }
    }

    // Ensure there is valid data for training
    if (target.isEmpty || features.isEmpty) {
      print("No valid data for training after parsing.");
      trainingMessage.value = "No valid data for training.";
      return;
    }

    // Print parsed data for debugging
    print("Parsed Target: $target");
    print("Parsed Features: $features");

    // Initialize and fit the polynomial regression model
    trainedModel = PolynomialRegressionModel(degree: degree);
    await trainedModel!.fit(features, target, epochs: epochs, learningRate: learningRate);

    // Create text controllers for each feature (based on the number of features in the dataset)
    featureControllers = List.generate(features[0].length, (_) => TextEditingController());
    print("Model training completed.");
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
    List<double> prediction = trainedModel!.predict([features]);

    // Display the result
    predictionResult.value = "Predicted Value: ${prediction[0]}";
    print("Prediction Result: ${prediction[0]}");
  }
}
