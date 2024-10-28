import 'dart:math';

class SVMClassifier {
  List<double>? weights;
  double? bias;

  // Train the model using Stochastic Gradient Descent (SGD)
  Future<void> fit(List<List<double>> features, List<int> target, {int epochs = 1000, double learningRate = 0.001, double lambda = 0.01}) async {
    int nSamples = features.length;
    int nFeatures = features[0].length;

    weights = List.filled(nFeatures, 0.0);
    bias = 0;

    for (int epoch = 0; epoch < epochs; epoch++) {
      for (int i = 0; i < nSamples; i++) {
        double condition = target[i] * (dotProduct(features[i], weights!) + bias!);
        if (condition >= 1) {
          // Correctly classified, apply regularization
          for (int j = 0; j < weights!.length; j++) {
            weights![j] -= learningRate * (2 * lambda * weights![j]);
          }
        } else {
          // Misclassified, update weights and bias
          for (int j = 0; j < weights!.length; j++) {
            weights![j] += learningRate * (target[i] * features[i][j] - 2 * lambda * weights![j]);
          }
          bias = bias! + learningRate * target[i];
        }
      }
    }
  }

  // Predict the labels for the input features
  List<int> predict(List<List<double>> features) {
    List<int> predictions = [];
    for (var feature in features) {
      double result = dotProduct(feature, weights!) + bias!;
      predictions.add(result >= 0 ? 1 : -1); // Class labels are -1 and 1
    }
    return predictions;
  }

  // Calculate accuracy of the model
  double calculateAccuracy(List<List<double>> features, List<int> target) {
    List<int> predictions = predict(features); // Get predictions from the model
    int correctPredictions = 0;

    // Compare predictions with actual target values
    for (int i = 0; i < predictions.length; i++) {
      if (predictions[i] == target[i]) {
        correctPredictions++;
      }
    }

    return (correctPredictions / predictions.length) * 100; // Return accuracy as a percentage
  }

  // Helper function to calculate the dot product between features and weights
  double dotProduct(List<double> feature, List<double> weights) {
    double result = 0.0;
    for (int i = 0; i < feature.length; i++) {
      result += feature[i] * weights[i];
    }
    return result;
  }
}
