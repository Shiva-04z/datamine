import 'dart:math';

class RidgeRegressionModel {
  List<double>? weights; // Coefficients for the features
  double bias = 0.0; // Intercept, initialized to 0
  double lambda; // Regularization parameter

  RidgeRegressionModel({required this.lambda});

  // Fit the Ridge regression model to the data
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

      // Update weights and bias with L2 regularization (Ridge penalty)
      for (int j = 0; j < n; j++) {
        weightGradients[j] += (2 * lambda * weights![j]); // Add L2 penalty
        weights![j] -= learningRate * weightGradients[j]; // Update weight
      }
      bias -= learningRate * biasGradient; // Update bias

      // Optional: print the loss for monitoring
      if (epoch % 100 == 0) {
        double loss = _calculateLoss(predictions, target);
        print("Epoch: $epoch, Loss: $loss");
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

  // Method to update lambda (L2 Regularization term)
  void setLambda(double newLambda) {
    lambda = newLambda;
  }

  // Calculate Mean Absolute Percentage Error (MAPE)
  double calculateMAPE(List<double> predictions, List<double> target) {
    double mape = 0.0;
    int validCount = 0; // Count of non-zero targets to calculate MAPE correctly

    // Iterate through predictions and target values
    for (int i = 0; i < predictions.length; i++) {
      if (target[i] != 0) { // Check for non-zero target values to avoid division by zero
        mape += (predictions[i] - target[i]).abs() / target[i];
        validCount++;
      }
    }

    // If no valid (non-zero) targets found, return NaN to indicate an invalid MAPE calculation
    if (validCount == 0) {
      return double.nan;
    }

    return (mape / validCount) * 100; // Return MAPE as a percentage
  }

}
