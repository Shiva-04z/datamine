import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'upload_page_controller.dart';

class UploadPageView extends GetView<UploadPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Upload Page",style: TextStyle(color: Colors.white),),
        ),
        body: Stack(
          children: [
            const SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image(
                image: AssetImage("assets/background/img_1.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.1),
            ),
            SingleChildScrollView(
              child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Name Your DataSet",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: controller.nameController,
                            style: TextStyle(color:Colors.white),
                            validator: (value) =>
                                controller.validateField(value!),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                    borderSide:
                                    BorderSide(color: Colors.white)),
                                label: Text(
                                  "Data Set Name",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ))),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Author Name",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: controller.authorNameController,
                            style: TextStyle(color:Colors.white),
                            validator: (value) =>
                                controller.validateField(value!),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                    borderSide:
                                    BorderSide(color: Colors.white)),
                                label: Text(
                                  "Author Name",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ))),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Problem Type",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                                          children: [
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Radio<String>(
                                    value: "Classification",
                                    groupValue: controller.problemType.value,
                                    onChanged: (value) {
                                      controller.problemType.value = value!;
                                    },
                                  ),
                                ),
                                Text(
                                  "Classification",
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(width: 20),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Radio<String>(
                                    value: "Regression",
                                    groupValue: controller.problemType.value,
                                    onChanged: (value) {
                                      controller.problemType.value = value!;
                                    },
                                  ),
                                ),
                                Text(
                                  "Regression",
                                  style: TextStyle(color: Colors.white),
                                ),
                                                          ],
                                                        )
                              ],
                            ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Other Comment",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: controller.otherInfoController,
                            style: TextStyle(color:Colors.white),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                    borderSide:
                                    BorderSide(color: Colors.white)),
                                label: Text(
                                  "Other Comment",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ))),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                controller.pickFile();
                              },
                              icon: Icon(Icons.upload_file),
                              label: const Text("Upload File"),
                            ),
                            const SizedBox(width: 20),
                            Obx(() {
                              return Text(
                                controller.selectedFile.value != null
                                    ? "File Selected"
                                    : "No file selected",
                                style: TextStyle(color: Colors.white),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(
                                () => controller.isUploading.value
                                ? Center(child: CircularProgressIndicator())
                                : ElevatedButton(
                              onPressed: () {
                                controller.submitForm();
                              },
                              child: const Text("Submit"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}
