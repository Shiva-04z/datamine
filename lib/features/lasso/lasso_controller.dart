import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:datamine/core/globals.dart' as glb;
import 'package:csv/csv.dart';
import 'dart:convert';
import 'model/lasso.dart'; // Import your Lasso regression model

class LassoRegressionController extends GetxController {
  var epochsController = TextEditingController();
  var learningRateController = TextEditingController();
  var lambdaController = TextEditingController(); // L1 Regularization (Lambda) controller
  var isTraining = false.obs;
  var trainingMessage = ''.obs;
  var predictionResult = ''.obs;
  var mapeResult = ''.obs; // To store MAPE result

  List<TextEditingController> featureControllers = [];
  List<String> featureNames = []; // List to store feature names
  LassoRegressionModel? trainedModel;

  LassoRegressionController();

  @override
  void onInit() {
    // Initialize the model within the controller with lambda = 0 initially
    trainedModel = LassoRegressionModel(lambda: 0.0);
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
    mapeResult.value = "";
    double mape =0.0;// Reset MAPE result

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

      // Train the Lasso regression model
      await trainLassoRegressionModel(csvData, epochs, learningRate, lambda);

      // Calculate and display MAPE after training
      mape = await calculateMAPE(csvData);
      trainingMessage.value = "Lasso model trained successfully.with ${epochs} epochs , ${learningRate} learning rate and ${lambda} regulariztion.\nMean Absolute Percentage Error: ${mape.toStringAsFixed(2)}%";

    } catch (e) {
      trainingMessage.value = "Error during training: ${e.toString()}";
      print("Training error: $e");  // Added error print for debugging
    } finally {
      isTraining.value = false;
    }
  }

  Future<void> trainLassoRegressionModel(List<List<dynamic>> data, int epochs, double learningRate, double lambda) async {
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

    // Initialize and fit the Lasso regression model
    await trainedModel?.fit(features, target, epochs: epochs, learningRate: learningRate);

    // Create text controllers for each feature (based on the number of features in the dataset)
    featureControllers = List.generate(features[0].length, (_) => TextEditingController());
    print("Lasso model training completed.");
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
    predictionResult.value = "Predicted Value: ${prediction[0].toStringAsFixed(2)}";
    print("Prediction Result: ${prediction[0]}");
  }

  // Method to calculate MAPE based on training data
  double calculateMAPE(List<List<dynamic>> data) {
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

    // Ensure there is valid data for MAPE calculation
    if (target.isEmpty || features.isEmpty) {
      print("No valid data for MAPE calculation.");
      return 0.0;
    }

    // Use the trained model to predict on the training data
    List<double> predictions = trainedModel!.predict(features);

    // Calculate and return MAPE
    return trainedModel!.calculateMAPE(predictions, target);
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
}
