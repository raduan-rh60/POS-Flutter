import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final TextEditingController _categoryName = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }

  List<Map<String, dynamic>>? categories;

  getCategory() async {
    var categoryResponse =
        await http.get(Uri.parse("http://$ip:8080/api/category"));
    var categoryData = jsonDecode(categoryResponse.body);

    setState(() {
      categories = List<Map<String, dynamic>>.from(categoryData);
    });
  }

  postCategory() async {
    var brandResponse =
        await http.post(Uri.parse("http://$ip:8080/api/category/save"),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'name': _categoryName.text,
            }));
    if (brandResponse.statusCode == 200) {
      setState(() {
        getCategory();
      });
    } else {
      print('error post Brand');
    }
  }

  @override
  Widget build(BuildContext context) {
    return categories != null
        ? Scaffold(
            appBar: AppBar(
              title: Text("Categories"),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          controller: _categoryName,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            label: Text("Category Name"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          postCategory();
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.deepPurpleAccent),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Add Category",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height - 400,
                  child: ListView.builder(
                    itemCount: categories!.length,
                    itemBuilder: (context, index) {
                      var category = categories![index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                            category["name"],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle:
                              Text("Products: ${category["productCount"]}"),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        : Container(child: CircularProgressIndicator());
  }
}
