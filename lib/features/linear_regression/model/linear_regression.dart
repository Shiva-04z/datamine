import 'dart:math';

class LinearRegressionModel {
  List<double>? weights; // Coefficients for the features
  double bias = 0.0; // Intercept, initialized to 0

  // Fit the linear regression model to the data
  Future<void> fit(List<List<double>> features, List<double> target, {required int epochs, required double learningRate}) async {
    int m = features.length; // Number of training examples
    int n = features[0].length; // Number of features

    // Initialize weights
    weights = List<double>.filled(n, 0.0);

    for (int epoch = 0; epoch < epochs; epoch++) {
      // Predictions based on current weights and bias
      List<double> predictions = predict(features);

      // Calculate gradients
      List<double> weightGradients = List<double>.filled(n, 0.0);
      double biasGradient = 0.0;

      for (int i = 0; i < m; i++) {
        double error = predictions[i] - target[i];
        for (int j = 0; j < n; j++) {
          weightGradients[j] += (2 / m) * error * features[i][j]; // Gradient for each weight
        }
        biasGradient += (2 / m) * error; // Gradient for bias
      }

      // Update weights and bias
      for (int j = 0; j < n; j++) {
        weights![j] -= learningRate * weightGradients[j]; // Update weights
      }
      bias -= learningRate * biasGradient; // Update bias

      // Optional: print the loss for monitoring
      if (epoch % 100 == 0) {
        double loss = _calculateLoss(predictions, target);
        double mape = calculateMAPE(predictions, target); // Calculate MAPE
        print("Epoch: $epoch, Loss: $loss, MAPE: $mape%");
      }
    }
  }

  // Make predictions using the trained model
  List<double> predict(List<List<double>> features) {
    List<double> predictions = [];

    for (var feature in features) {
      double prediction = bias; // Start with bias
      for (int j = 0; j < weights!.length; j++) {
        prediction += weights![j] * feature[j]; // Add weighted features
      }
      predictions.add(prediction);
    }

    return predictions;
  }

  // Calculate the Mean Squared Error loss
  double _calculateLoss(List<double> predictions, List<double> target) {
    double loss = 0.0;
    for (int i = 0; i < predictions.length; i++) {
      loss += pow(predictions[i] - target[i], 2); // Squared error
    }
    return loss / predictions.length; // Mean loss
  }

  // Calculate Mean Absolute Percentage Error (MAPE)
  // Calculate Mean Absolute Percentage Error (MAPE)
  double calculateMAPE(List<double> predictions, List<double> actual) {
    if (predictions.isEmpty || actual.isEmpty) {
      print("Error: Predictions or actual values list is empty.");
      return double.nan; // Return NaN for error handling
    }

    double mape = 0.0;
    int count = 0;

    for (int i = 0; i < predictions.length; i++) {
      if (actual[i] != 0) { // Avoid division by zero
        mape += (predictions[i] - actual[i]).abs() / actual[i];
        count++; // Count valid entries
      } else {
        print("Warning: Actual value at index $i is zero, skipping this entry.");
      }
    }

    if (count > 0) {
      return (mape / count) * 100; // Return MAPE as a percentage
    } else {
      print("Error: No valid entries to calculate MAPE.");
      return double.nan; // Handle as needed
    }
  }


}