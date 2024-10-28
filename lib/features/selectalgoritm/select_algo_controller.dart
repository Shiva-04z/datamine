import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:datamine/core/globals.dart' as glb;

class SelectAlgoController extends GetxController {
  RxString name = "".obs;
  RxString authorName = "".obs;

  RxString problemType = "".obs;
  RxList<String> algorithms = <String>[].obs;  // Observable list of algorithms
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Datasets')
          .doc(glb.dataDoc.value)
          .get();

      if (snapshot.exists) {
        name.value = snapshot['Name'];
        authorName.value = snapshot['AuthorName'];
        glb.fileUrl.value = snapshot['FileUrl'];
        problemType.value = snapshot['ProblemType'];

        // Call method to set algorithms based on problemType
        setAlgorithms(problemType.value);
      } else {
        Get.snackbar("Error", "Document does not exist");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void setAlgorithms(String problemType) {
    if (problemType == "Classification") {
      algorithms.assignAll(["Decision Tree", "Random Forest", "SVM", "Naive Bayes"]);
    } else if (problemType == "Regression") {
      algorithms.assignAll(["Linear Regression", "Lasso", "Ridge", "Polynomial Regression"]);
    }  else {
      algorithms.assignAll(["No algorithms available for this problem type"]);
    }
  }
}
