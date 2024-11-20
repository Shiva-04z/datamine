import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:datamine/core/globals.dart' as glb;
import 'model/naive_bays.dart'; // Your Naive Bayes model import

class NaiveBayesController extends GetxController {
  var featureControllers = <TextEditingController>[];
  var nFeaturesController = TextEditingController();

  // Reactive state variables
  var isTraining = false.obs;
  var trainingMessage = ''.obs;
  var predictionResult = ''.obs;
  var accuracyResult = ''.obs; // New state variable for accuracy

  List<String> featureNames = []; // Store feature names
  NaiveBayesModel? trainedModel; // Instance of Naive Bayes model

  @override
  void onClose() {
    // Dispose of controllers to free resources
    nFeaturesController.dispose();
    for (var controller in featureControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> trainModel() async {
    isTraining.value = true;
    trainingMessage.value = "";
    predictionResult.value = "";
    accuracyResult.value = ""; // Reset accuracy result

    try {
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
      int nFeatures = featureNames.length;

      // Train the Naive Bayes model
      await trainNaiveBayesModel(csvData, nFeatures);
      trainingMessage.value = "Model loaded successfully";

      // Calculate and display accuracy
      await checkAccuracy(csvData);
    } catch (e) {
      trainingMessage.value = "Error during training: ${e.toString()}";
      print("Training error: $e");
    } finally {
      isTraining.value = false;
    }
  }

  Future<void> checkAccuracy(List<List<dynamic>> csvData) async {
    if (trainedModel == null) {
      accuracyResult.value = "Model is not trained.";
      return;
    }

    // Parse features and target from CSV data (skip the header)
    List<double> target = [];
    List<List<double>> features = [];

    for (var row in csvData.sublist(1)) {
      if (row.length < 2) continue;

      try {
        target.add((row[0] as num).toDouble());
        List<double> featureRow = row.sublist(1).map((e) => (e as num).toDouble()).toList();
        features.add(featureRow);
      } catch (e) {
        print("Error parsing row: $row, error: $e");
      }
    }

    // Validate parsed data
    if (target.isEmpty || features.isEmpty) {
      accuracyResult.value = "No valid data for accuracy check.";
      return;
    }

    // Make predictions on training data
    List<double> predictedLabels = trainedModel!.predict(features);

    // Calculate accuracy
    double accuracy = trainedModel!.calculateAccuracy(target, predictedLabels);
   trainingMessage.value += "\nAccuracy: ${(accuracy * 100).toStringAsFixed(2)}%";
  }

  Future<void> trainNaiveBayesModel(List<List<dynamic>> data, int nFeatures) async {
    List<double> target = [];
    List<List<double>> features = [];

    // Check for sufficient data
    if (data.isEmpty || data.length < 2) {
      trainingMessage.value = "No valid data for training.";
      return;
    }

    // Parse the CSV data
    for (var row in data.sublist(1)) {
      if (row.length < 2) {
        print("Invalid row length, skipping row: $row");
        continue;
      }

      try {
        // Assuming the first column is the target
        target.add((row[0] as num).toDouble());
        List<double> featureRow = row.sublist(1).map((e) => (e as num).toDouble()).toList();
        features.add(featureRow);
      } catch (e) {
        print("Error parsing row: $row, error: $e");
      }
    }

    // Validate parsed data
    if (target.isEmpty || features.isEmpty) {
      trainingMessage.value = "No valid data for training.";
      return;
    }

    // Initialize and fit the Naive Bayes model
    trainedModel = NaiveBayesModel();
    await trainedModel!.fit(features, target);

    // Prepare feature input controllers for predictions
    featureControllers = List.generate(nFeatures, (_) => TextEditingController());
    print("Model training completed.");
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
      print("Prediction error: Model not trained.");
      return;
    }

    // Gather features from user input
    List<double> features = featureControllers
        .map((controller) => double.tryParse(controller.text) ?? 0.0)
        .toList();

    // Make prediction
    List<double> prediction = trainedModel!.predict([features]);

    if(prediction[0] == 0.0){
      predictionResult.value = "Foe";
    } else if(prediction[0] == 1.0){
      predictionResult.value = "Friend";
    }
    else
    {
      predictionResult.value="${prediction[0]}";
    }
  }
}
