import 'package:datamine/features/selection_page/selection_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectionPageView extends GetView<SelectionPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select a DataSet",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      bottomSheet: Wrap(
        children: [
          Container(
            width: double.infinity,
            color: Colors.black,
            child: ElevatedButton(
              onPressed: () {
                controller.toAdd();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(4),
                shape: ContinuousRectangleBorder(),
                backgroundColor: Colors.purple,
              ),
              child: const Text(
                "Add Dataset",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage("assets/background/img_1.png"),
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.6),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      controller.filterDocuments(value); // Call filterDocuments on change
                    },
                    style: TextStyle(color:Colors.white),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),

                      suffixIcon: Icon(Icons.search),
                      label: Text("Search"),
                    ),
                  ),
                ),
                Obx(() {
                  if (controller.filteredDocuments.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView.builder(
                        itemCount: controller.filteredDocuments.length,
                        itemBuilder: (context, index) {
                          var doc = controller.filteredDocuments[index];
                          return Card(
                            color: Colors.black.withOpacity(0.5),
                            elevation: 5,
                            margin: EdgeInsets.all(10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Dataset Name : ${doc['Name']}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "Author Name : ${doc['AuthorName']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "Problem Type: ${doc['ProblemType']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "Additional Info: ${doc['Other']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          // Implement edit functionality
                                          controller.toApply(doc);
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
