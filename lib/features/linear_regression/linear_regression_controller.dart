import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:datamine/core/globals.dart' as glb;
import 'model/linear_regression.dart'; // Your linear regression model import

class LinearRegressionController extends GetxController {
  var epochsController = TextEditingController();
  var learningRateController = TextEditingController();
  var isTraining = false.obs;
  var trainingMessage = ''.obs;
  var predictionResult = ''.obs;

  List<TextEditingController> featureControllers = [];
  List<String> featureNames = []; // List to store feature names
  LinearRegressionModel? trainedModel;
  final LinearRegressionModel model = LinearRegressionModel(); // Model instance

  @override
  void onClose() {
    epochsController.dispose();
    learningRateController.dispose();
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
      int epochs = int.parse(epochsController.text);
      double learningRate = double.parse(learningRateController.text);

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

      // Train the linear regression model
      await trainLinearRegressionModel(csvData, epochs, learningRate);
    } catch (e) {
      trainingMessage.value = "Error during training: ${e.toString()}";
      print("Training error: $e");  // Added error print for debugging
    } finally {
      isTraining.value = false;
    }
  }

  Future<void> trainLinearRegressionModel(List<List<dynamic>> data, int epochs, double learningRate) async {
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

    // Initialize and fit the linear regression model
    await model.fit(features, target, epochs: epochs, learningRate: learningRate);

    // Make predictions to calculate MAPE
    List<double> predictions = model.predict(features);
    double mape = model.calculateMAPE(predictions, target); // Calculate MAPE

    // Assign the trained model to the controller
    trainedModel = model;

    // Create text controllers for each feature (based on the number of features in the dataset)
    featureControllers = List.generate(features[0].length, (_) => TextEditingController());

    // Display training completion message with MAPE
    trainingMessage.value = "Model trained successfully with $epochs epochs and learning rate of $learningRate.\nMAPE: ${mape.toStringAsFixed(2)}%";
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
    List<double> prediction = trainedModel!.predict([features]);

    // Display the result
    predictionResult.value = "Predicted Value: ${prediction[0].toStringAsFixed(2)}";
    print("Prediction Result: ${prediction[0]}");
  }
}
