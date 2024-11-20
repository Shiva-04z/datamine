import 'dart:math';

class PolynomialRegressionModel {
  List<double>? coefficients; // Coefficients for the polynomial features
  int degree; // Degree of the polynomial

  PolynomialRegressionModel({required this.degree});

  // Fit the polynomial regression model to the data
  Future<void> fit(List<List<double>> features, List<double> target, {required int epochs, required double learningRate}) async {
    int m = features.length; // Number of training examples

    // Initialize coefficients
    coefficients = List<double>.filled(degree + 1, 0.0); // +1 for bias term

    for (int epoch = 0; epoch < epochs; epoch++) {
      // Predictions based on current coefficients
      List<double> predictions = predict(features);

      // Calculate gradients
      List<double> gradients = List<double>.filled(degree + 1, 0.0); // +1 for bias term

      for (int i = 0; i < m; i++) {
        double error = predictions[i] - target[i];

        // Update gradients for each coefficient
        for (int j = 0; j <= degree; j++) {
          gradients[j] += (2.0 / m) * error * pow(features[i][0], j); // Assuming single feature for polynomial
        }
      }

      // Update coefficients
      for (int j = 0; j <= degree; j++) {
        coefficients![j] -= learningRate * gradients[j]; // Gradient descent step
      }

      // Optional: print the loss for monitoring
      if (epoch % 100 == 0) {
        double loss = _calculateLoss(predictions, target);
        double mape = _calculateMAPE(predictions, target);
        print("Epoch: $epoch, Loss: $loss, MAPE: $mape%");
      }
    }
  }

  // Make predictions using the trained model
  List<double> predict(List<List<double>> features) {
    List<double> predictions = [];

    for (var feature in features) {
      double prediction = coefficients![0]; // Start with bias (constant term)
      for (int j = 1; j <= degree; j++) {
        prediction += coefficients![j] * pow(feature[0], j); // Add weighted polynomial terms
      }
      predictions.add(double.parse(prediction.toStringAsFixed(2)));
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

  // Calculate the Mean Absolute Percentage Error (MAPE)
  double _calculateMAPE(List<double> predictions, List<double> target) {
    double mape = 0.0;
    for (int i = 0; i < predictions.length; i++) {
      if (target[i] != 0) {
        mape += (predictions[i] - target[i]).abs() / target[i]; // Absolute percentage error
      }
    }
    return (mape / predictions.length) * 100; // Mean percentage error
  }
}
