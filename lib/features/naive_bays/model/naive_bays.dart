import 'dart:math';

class NaiveBayesModel {
  late Map<String, Map<String, double>> likelihoods;
  late Map<double, double> priors;
  List<double> classes = [];

  NaiveBayesModel();

  Future<void> fit(List<List<double>> features, List<double> target) async {
    // Calculate the unique classes and their probabilities (priors)
    classes = target.toSet().toList();
    priors = {};
    for (double classValue in classes) {
      priors[classValue] = target.where((value) => value == classValue).length / target.length;
    }

    // Calculate the likelihoods (mean and variance) for each feature in each class
    likelihoods = {};
    for (int i = 0; i < features[0].length; i++) {
      for (double classValue in classes) {
        List<double> featureValues = features
            .asMap()
            .entries
            .where((entry) => target[entry.key] == classValue)
            .map((entry) => entry.value[i])
            .toList();

        // Calculate mean and variance for each class-feature combination
        double mean = featureValues.reduce((a, b) => a + b) / featureValues.length;
        double variance = featureValues.fold(0.0, (sum, value) => sum + (value - mean) * (value - mean)) / featureValues.length;

        likelihoods['feature_${i}_class_$classValue'] = {
          'mean': mean,
          'variance': variance,
        };
      }
    }
  }

  List<double> predict(List<List<double>> features) {
    return features.map((featureSet) {
      Map<double, double> probabilities = {};
      for (double classValue in classes) {
        double classProb = priors[classValue] ?? 0.0;

        for (int i = 0; i < featureSet.length; i++) {
          double value = featureSet[i];
          double mean = likelihoods['feature_${i}_class_$classValue']?['mean'] ?? 0.0;
          double variance = likelihoods['feature_${i}_class_$classValue']?['variance'] ?? 1.0;

          // Calculate the Gaussian probability density function
          double exponent = pow(value - mean, 2) / (2 * variance);
          double probability = (1 / sqrt(2 * pi * variance)) * exp(-exponent);

          classProb *= probability;
        }
        probabilities[classValue] = classProb;
      }

      // Return the class with the maximum probability
      return probabilities.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }).toList();
  }

  double calculateAccuracy(List<double> trueLabels, List<double> predictedLabels) {
    if (trueLabels.length != predictedLabels.length) {
      throw Exception("Length of true labels and predicted labels must be the same.");
    }

    int correctPredictions = 0;
    for (int i = 0; i < trueLabels.length; i++) {
      if (trueLabels[i] == predictedLabels[i]) {
        correctPredictions++;
      }
    }
    return correctPredictions / trueLabels.length;
  }
}
