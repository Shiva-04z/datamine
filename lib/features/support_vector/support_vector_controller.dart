import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:datamine/core/globals.dart' as glb;
import 'model/support_vector.dart'; // Import SVM model

class SVMController extends GetxController {
  var epochsController = TextEditingController();
  var learningRateController = TextEditingController();
  var lambdaController = TextEditingController();
  var isTraining = false.obs;
  var trainingMessage = ''.obs;
  var predictionResult = ''.obs;
  var accuracyResult = ''.obs; // Variable to store accuracy result

  List<TextEditingController> featureControllers = [];
  List<String> featureNames = []; // List to store feature names
  SVMClassifier? trainedModel;
  final SVMClassifier model = SVMClassifier(); // SVM model instance

  @override
  void onClose() {
    epochsController.dispose();
    learningRateController.dispose();
    lambdaController.dispose();
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
      // Get user input
      int epochs = int.parse(epochsController.text);
      double learningRate = double.parse(learningRateController.text);
      double lambda = double.parse(lambdaController.text);

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

      // Train the SVM model
      await trainSVMModel(csvData, epochs, learningRate, lambda);

      // Calculate accuracy
      double accuracy = calculateAccuracy(csvData, trainedModel!);

      accuracyResult.value = "Model accuracy: ${accuracy.toStringAsFixed(2)}%";

      trainingMessage.value = "Model trained successfully with $epochs epochs, learning rate $learningRate, and lambda $lambda.\n${accuracyResult.value}";
    } catch (e) {
      trainingMessage.value = "Error during training: ${e.toString()}";
    } finally {
      isTraining.value = false;
    }
  }

  Future<void> trainSVMModel(List<List<dynamic>> data, int epochs, double learningRate, double lambda) async {
    List<int> target = [];
    List<List<double>> features = [];

    // Parse CSV data into features and target
    for (var row in data.sublist(1)) {
      target.add((row[0] as num).toInt());
      features.add(row.sublist(1).map((e) => (e as num).toDouble()).toList());
    }

    // Initialize and train the SVM model
    await model.fit(features, target, epochs: epochs, learningRate: learningRate, lambda: lambda);

    trainedModel = model;

    // Create text controllers for each feature (based on the number of features in the dataset)
    featureControllers = List.generate(features[0].length, (_) => TextEditingController());
  }

  // Calculate accuracy of the model based on the training data
  double calculateAccuracy(List<List<dynamic>> data, SVMClassifier model) {
    List<int> target = [];
    List<List<double>> features = [];

    // Parse CSV data for accuracy calculation
    for (var row in data.sublist(1)) {
      target.add((row[0] as num).toInt());
      features.add(row.sublist(1).map((e) => (e as num).toDouble()).toList());
    }

    // Get predictions from the model
    List<int> predictions = model.predict(features);

    // Calculate accuracy
    int correctPredictions = 0;
    for (int i = 0; i < predictions.length; i++) {
      if (predictions[i] == target[i]) {
        correctPredictions++;
      }
    }

    return (correctPredictions / target.length) * 100; // Return accuracy as a percentage
  }

  Future<List<List<dynamic>>> downloadAndPrepareCSV(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<List<dynamic>> csvData = const CsvToListConverter().convert(response.body);
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

    // Collect the features from user input
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
}
