import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:datamine/core/globals.dart' as glb;
import '../../navigation/routes_constant.dart';

class SelectionPageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isCheck = false.obs;
  RxList<DocumentSnapshot> documents = RxList<DocumentSnapshot>();
  RxList<DocumentSnapshot> filteredDocuments = RxList<DocumentSnapshot>(); // For filtered documents
  RxString searchQuery = ''.obs; // To store the search query

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void toAdd() {
    Get.toNamed(RoutesConstant.upload);
  }

  void toApply(DocumentSnapshot doc) {
    glb.dataDoc.value = doc.id;
    Get.toNamed(RoutesConstant.viewAlgo);
  }

  void deleteDocument(DocumentSnapshot doc) async {
    try {
      await _firestore.collection("Datasets").doc(doc.id).delete();
      fetchData(); // Refresh data after deletion
      Get.snackbar("Deleted", "Document deleted successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete document: $e");
    }
  }

  void updateCheckbox(DocumentSnapshot doc, bool? value) {
    if (value != null) {
      _firestore.collection("Datasets").doc(doc.id).update({'isChecked': value});
      fetchData();
    }
  }

  void fetchData() async {
    try {
      final snapshots = await _firestore.collection("Datasets").get();
      documents.assignAll(snapshots.docs);
      filteredDocuments.assignAll(snapshots.docs); // Initialize filtered documents
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch data: $e");
    }
  }

  // Method to filter documents based on the search query
  void filterDocuments(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredDocuments.assignAll(documents); // Show all documents if query is empty
    } else {
      filteredDocuments.assignAll(documents.where((doc) {
        return (doc['Name'] as String).toLowerCase().contains(query.toLowerCase());
      }).toList());
    }
  }
}
