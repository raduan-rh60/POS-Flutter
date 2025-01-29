import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class Brands extends StatefulWidget {
  const Brands({super.key});

  @override
  State<Brands> createState() => _BrandsState();
}

class _BrandsState extends State<Brands> {
  final TextEditingController _brandName = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBrand();
  }

  List<Map<String, dynamic>>? brands;

  getBrand() async {
    var brandResponse =
        await http.get(Uri.parse("http://$ip:8080/api/brand"));
    var brandData = jsonDecode(brandResponse.body);

    setState(() {
      brands = List<Map<String, dynamic>>.from(brandData);
    });
  }

  postBrand() async {
    var brandResponse =
        await http.post(Uri.parse("http://$ip:8080/api/brand/save"),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'name': _brandName.text,
            }));
    if (brandResponse.statusCode == 200) {
      setState(() {
        getBrand();
      });
    } else {
      print('error post Brand');
    }
  }

  @override
  Widget build(BuildContext context) {
    return brands != null
        ? Scaffold(
            appBar: AppBar(
              title: Text("Brands"),
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
                          controller: _brandName,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            label: Text("Brand Name"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          postBrand();
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
                            "Add Brand",
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
                    itemCount: brands!.length,
                    itemBuilder: (context, index) {
                      var brand = brands![index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                            brand["name"],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Products: ${brand["productCount"]}"),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
