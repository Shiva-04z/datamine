import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datamine/navigation/routes_constant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class UploadPageController extends GetxController {
  // Keys and Controllers
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController otherInfoController = TextEditingController();

  // Rx Variables
  RxString accessType = "".obs;
  RxString problemType = "".obs;
  RxString fileUrl = "".obs;
  Rx<dynamic> selectedFile = Rx<dynamic>(null); // Changed to dynamic for web compatibility
  RxBool isUploading = false.obs; // For the circular progress indicator

  // File picking logic
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'], // Allow only CSV files
      withData: kIsWeb, // Set to true for web compatibility
    );

    if (result != null) {
      if (kIsWeb) {
        // For web, store the bytes
        selectedFile.value = result.files.single.bytes;
      } else {
        // For mobile, store the file path
        selectedFile.value = File(result.files.single.path!);
      }
    }
  }

  // Form Validation
  String? validateField(String value) {
    if (value.isEmpty) {
      return "This field cannot be empty";
    }
    return null;
  }

  // File validation
  String? validateFile() {
    if (selectedFile.value == null) {
      return "Please upload a file.";
    }
    return null;
  }

  // Actual file upload logic
  Future<void> uploadFile() async {
    if (selectedFile.value != null) {
      try {
        isUploading.value = true; // Start showing the progress indicator

        // Define the file storage path
        String fileName = DateTime.now().millisecondsSinceEpoch.toString() + "_" +
            (kIsWeb ? "web_${DateTime.now().millisecondsSinceEpoch}" : selectedFile.value!.path.split('/').last);

        Reference storageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');

        if (kIsWeb && selectedFile.value is Uint8List) {
          // For web, upload as bytes
          await storageRef.putData(selectedFile.value as Uint8List);
        } else if (selectedFile.value is File) {
          // For mobile, upload as a file
          await storageRef.putFile(selectedFile.value as File);
        }

        // Get the file's download URL
        fileUrl.value = await storageRef.getDownloadURL();
        print("File uploaded: ${fileUrl.value}");

        Get.snackbar("Success", "File uploaded successfully!");

        // Stop the progress indicator
        isUploading.value = false;
      } catch (e) {
        isUploading.value = false;
        Get.snackbar("Error", "File upload failed: ${e.toString()}");
      }
    }
  }

  // Add form data to Firestore, including the file URL
  Future<void> addData() async {
    try {
      await FirebaseFirestore.instance.collection("Datasets").add({
        'Name': nameController.text,
        'AuthorName': authorNameController.text,
        'Other': otherInfoController.text,
        'AccessType': accessType.value,
        'ProblemType': problemType.value,
        'FileUrl': fileUrl.value,
      });
      Get.snackbar("Success", "Data added to Firestore!");
      Get.toNamed(RoutesConstant.home);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Form submission logic
  void submitForm() async {
    if (formKey.currentState!.validate() && selectedFile.value != null) {
      await uploadFile(); // Upload file first
      if (fileUrl.value.isNotEmpty) {
        await addData();
        // If upload successful, add data to Firestore
      }
    } else {
      Get.snackbar("Error", "Please complete the form and upload a valid file.");
    }
  }

  @override
  void onClose() {
    // Dispose of controllers to avoid memory leaks
    nameController.dispose();
    authorNameController.dispose();
    super.onClose();
  }
}
