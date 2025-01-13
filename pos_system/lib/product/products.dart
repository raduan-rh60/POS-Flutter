import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pos_system/Home/home.dart';
import 'package:pos_system/product/brand.dart';
import 'package:pos_system/product/category.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductData();
  }

  List<Map<String, dynamic>>? products;

  getProductData() async {
    var productsResponse =
        await http.get(Uri.parse("http://localhost:8080/api/product"));
    var productData = jsonDecode(productsResponse.body);

    setState(() {
      products = List<Map<String, dynamic>>.from(productData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Products"),
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.menu), // Drawer icon
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer(); // Open the drawer
                    },
                  );
                }
              ),
            ),
          ],
        ),

        endDrawer: Align(
          alignment: Alignment.bottomRight,
          child: Drawer(
            // width: MediaQuery.sizeOf(context).width/2,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 60,
                ),
                ListTile(
                  leading: Icon(Icons.dashboard_outlined),
                  title: Text('Dashboard'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));

                  },
                ),
                ListTile(
                  leading: Icon(Icons.add_box_outlined),
                  title: Text('Add Product'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));

                  },
                ),
                ListTile(
                  leading: Icon(Icons.category_outlined),
                  title: Text('Categories'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Category()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.branding_watermark_outlined),
                  title: Text('Brands'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Brands()));
                  },
                ),
              ],
            ),
          ),
        ),

        floatingActionButton:SizedBox(
          width: 90,
          child: FloatingActionButton(
            onPressed: () {},
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline_sharp),
                  Text(" Add")
                ],
              ),
            ),
          ),
        ) ,
        body: products != null
            ? ListView.builder(
              itemCount: products!.length,
              itemBuilder: (context, index) {
                var product = products![index];
                var imageData = base64Decode("${product["image"]}");
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.memory(
                      imageData,
                      width: 60,
                      height: 60,
                    ),
                    title: Text(product["name"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Category: ",
                              style:
                                  TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(product["category"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Brand: ",
                              style:
                                  TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(product["brand"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Stock: ",
                              style:
                                  TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("${product["stock"]}",
                                style: TextStyle(
                                    color: product["stock"] > 200
                                        ? Colors.black
                                        : Colors.red)),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Price: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            Text("${product["price"]}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
            : Center(
                child: CircularProgressIndicator(
                color: Colors.deepPurpleAccent,
              )));
  }
}
