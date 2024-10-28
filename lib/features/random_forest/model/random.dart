import 'dart:math';
import '../../decision_tree/model/decision_tree.dart'; // Importing your DecisionTreeClassifier

class RandomForestModel {
  int nTrees; // Number of trees in the forest
  int maxDepth; // Maximum depth for each tree
  int minSamplesSplit; // Minimum samples to split a node
  List<DecisionTreeClassifier> forest = []; // Collection of Decision Trees

  RandomForestModel({
    required this.nTrees,
    required this.maxDepth,
    required this.minSamplesSplit,
  });

  // Train the Random Forest Model
  Future<void> fit(List<List<double>> features, List<double> target) async {
    int nSamples = features.length;

    // Convert target to List<int> for classification
    List<int> targetInt = target.map((value) => value.toInt()).toList();

    for (int i = 0; i < nTrees; i++) {
      // Bootstrap sampling (with replacement)
      List<int> sampleIndices = List.generate(
        nSamples,
            (index) => Random().nextInt(nSamples),
      );

      List<List<double>> sampleFeatures = sampleIndices.map((i) => features[i]).toList();
      List<int> sampleTarget = sampleIndices.map((i) => targetInt[i]).toList();

      // Create and train a new decision tree
      DecisionTreeClassifier tree = DecisionTreeClassifier();
      await tree.fit(sampleFeatures, sampleTarget, maxDepth: maxDepth);
      forest.add(tree); // Add the trained tree to the forest
    }
  }

  // Make predictions using the forest (majority voting for classification)
  List<int> predict(List<List<double>> features) {
    List<int> predictions = [];

    for (var feature in features) {
      List<int> treePredictions = forest.map((tree) => tree.predict([feature])[0]).toList();
      int majorityVote = _majorityVote(treePredictions);
      predictions.add(majorityVote); // Store the majority vote
    }

    return predictions;
  }

  // Determine the majority vote
  int _majorityVote(List<int> predictions) {
    Map<int, int> frequency = {};
    for (var pred in predictions) {
      frequency[pred] = (frequency[pred] ?? 0) + 1; // Count frequency of each prediction
    }
    return frequency.entries.reduce((a, b) => a.value > b.value ? a : b).key; // Return the prediction with the highest frequency
  }

  // Calculate accuracy of the model
  double calculateAccuracy(List<int> trueLabels, List<int> predictedLabels) {
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
