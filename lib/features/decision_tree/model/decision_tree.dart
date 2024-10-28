import 'dart:math';

class DecisionTreeNode {
  double? threshold;
  int? featureIndex;
  int? label;
  DecisionTreeNode? left;
  DecisionTreeNode? right;

  DecisionTreeNode({this.threshold, this.featureIndex, this.label, this.left, this.right});
}

class DecisionTreeClassifier {
  DecisionTreeNode? root;

  Future<void> fit(List<List<double>> features, List<int> target, {int maxDepth = 10}) async {
    root = _buildTree(features, target, 0, maxDepth);
  }


  DecisionTreeNode _buildTree(List<List<double>> features, List<int> target, int depth, int maxDepth) {
    if (depth >= maxDepth || _isPure(target)) {
      return DecisionTreeNode(label: _majorityClass(target));
    }

    var bestSplit = _findBestSplit(features, target);
    int bestFeature = bestSplit['featureIndex']!;
    double bestThreshold = bestSplit['threshold']!;
    double bestGain = bestSplit['gain']!;
    List<List<double>> leftFeatures = bestSplit['leftFeatures']!;
    List<List<double>> rightFeatures = bestSplit['rightFeatures']!;
    List<int> leftTarget = bestSplit['leftTarget']!;
    List<int> rightTarget = bestSplit['rightTarget']!;

    if (bestGain == 0) {
      return DecisionTreeNode(label: _majorityClass(target));
    }


    DecisionTreeNode leftSubtree = _buildTree(leftFeatures, leftTarget, depth + 1, maxDepth);
    DecisionTreeNode rightSubtree = _buildTree(rightFeatures, rightTarget, depth + 1, maxDepth);

    return DecisionTreeNode(
      threshold: bestThreshold,
      featureIndex: bestFeature,
      left: leftSubtree,
      right: rightSubtree,
    );
  }

  List<int> predict(List<List<double>> features) {
    List<int> predictions = [];
    for (var feature in features) {
      predictions.add(_predictSingle(feature, root));
    }
    return predictions;
  }

  int _predictSingle(List<double> feature, DecisionTreeNode? node) {
    if (node!.label != null) {
      return node.label!;
    }
    if (feature[node.featureIndex!] <= node.threshold!) {
      return _predictSingle(feature, node.left);
    } else {
      return _predictSingle(feature, node.right);
    }
  }


  Map<String, dynamic> _findBestSplit(List<List<double>> features, List<int> target) {
    double bestGain = 0;
    int bestFeature = -1;
    double bestThreshold = 0;
    List<List<double>> bestLeftFeatures = [];
    List<List<double>> bestRightFeatures = [];
    List<int> bestLeftTarget = [];
    List<int> bestRightTarget = [];

    for (int featureIndex = 0; featureIndex < features[0].length; featureIndex++) {
      List<double> featureValues = features.map((e) => e[featureIndex]).toList();
      Set<double> thresholds = featureValues.toSet();

      for (var threshold in thresholds) {
        var left = <List<double>>[], right = <List<double>>[];
        var leftTarget = <int>[], rightTarget = <int>[];

        for (int i = 0; i < features.length; i++) {
          if (features[i][featureIndex] <= threshold) {
            left.add(features[i]);
            leftTarget.add(target[i]);
          } else {
            right.add(features[i]);
            rightTarget.add(target[i]);
          }
        }

        double gain = _calculateInformationGain(leftTarget, rightTarget, target);
        if (gain > bestGain) {
          bestGain = gain;
          bestFeature = featureIndex;
          bestThreshold = threshold;
          bestLeftFeatures = left;
          bestRightFeatures = right;
          bestLeftTarget = leftTarget;
          bestRightTarget = rightTarget;
        }
      }
    }

    return {
      'featureIndex': bestFeature,
      'threshold': bestThreshold,
      'gain': bestGain,
      'leftFeatures': bestLeftFeatures,
      'rightFeatures': bestRightFeatures,
      'leftTarget': bestLeftTarget,
      'rightTarget': bestRightTarget,
    };
  }


  bool _isPure(List<int> target) {
    return target.toSet().length == 1;
  }


  int _majorityClass(List<int> target) {
    Map<int, int> counts = {};
    for (var label in target) {
      counts[label] = (counts[label] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }


  double _calculateInformationGain(List<int> leftTarget, List<int> rightTarget, List<int> target) {
    double entropyBefore = _calculateEntropy(target);
    double entropyLeft = _calculateEntropy(leftTarget);
    double entropyRight = _calculateEntropy(rightTarget);
    double pLeft = leftTarget.length / target.length;
    double pRight = rightTarget.length / target.length;
    double entropyAfter = pLeft * entropyLeft + pRight * entropyRight;
    return entropyBefore - entropyAfter;
  }

  double _calculateEntropy(List<int> target) {
    Map<int, int> counts = {};
    for (var label in target) {
      counts[label] = (counts[label] ?? 0) + 1;
    }
    double entropy = 0.0;
    for (var count in counts.values) {
      double p = count / target.length;
      entropy -= p * log(p) / ln2; // Using natural log
    }
    return entropy;
  }
}
