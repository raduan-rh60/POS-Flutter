import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pos_system/pos/pos_cart.dart';

class PosProducts extends StatefulWidget {
  const PosProducts({super.key});

  @override
  State<PosProducts> createState() => _PosProductsState();
}

class _PosProductsState extends State<PosProducts> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductData();
    getCartProducts();
    getCategory();
  }

  List<Map<String, dynamic>>? products;
  List<Map<String, dynamic>>? cartItems;
  List<Map<String, dynamic>>? filteredProducts; // Filtered products for display
  List<Map<String, dynamic>>? categories;

  String? selectedCategory;

  final TextEditingController _searchController = TextEditingController();

  getProductData() async {
    var productsResponse =
        await http.get(Uri.parse("http://localhost:8080/api/product"));
    var productData = jsonDecode(productsResponse.body);

    setState(() {
      products = List<Map<String, dynamic>>.from(productData);
      filteredProducts = products;
    });
  }

  getCartProducts() async {
    var cartResponse =
        await http.get(Uri.parse("http://localhost:8080/api/cart"));
    if (cartResponse.statusCode == 200) {
      var cartData = jsonDecode(cartResponse.body);
      setState(() {
        cartItems = List<Map<String, dynamic>>.from(cartData);
      });
    } else {
      print("Failed to fetch cart products");
    }
  }

  passProduct(int productId) async {
    var passProduct = await http.post(
      Uri.parse("http://localhost:8080/api/cart/new?productId=$productId"),
      body: null,
    );
    if (passProduct.statusCode == 200) {
      await getCartProducts(); // Fetch updated cart items
      setState(() {}); // Trigger a rebuild to update the UI
    } else {
      // Handle errors if necessary
      print("Failed to add product to cart");
    }
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = products; // Reset to all products
      });
    } else {
      setState(() {
        filteredProducts = products!.where((product) {
          return product['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void searchProductByCategory(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = products; // Reset to all products
      });
    } else {
      setState(() {
        filteredProducts = products!.where((product) {
          return product['category']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void searchProductById(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = products; // Reset to all products
      });
    } else {
      setState(() {
        filteredProducts = products!.where((product) {
          return product['id']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  getCategory() async {
    var getCategories =
        await http.get(Uri.parse("http://localhost:8080/api/category"));
    if (getCategories.statusCode == 200) {
      var categoryResponse = jsonDecode(getCategories.body);
      setState(() {
        categories = List<Map<String, dynamic>>.from(categoryResponse);
      });
    } else {
      print("Failed to fetch categories");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Products"),
      ),
      floatingActionButton: (cartItems != null && cartItems!.isNotEmpty)
          ? AnimatedAlign(
              duration: Duration(seconds: 1),
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 100,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PosCart()));
                  },
                  child: Text("View Cart"),
                ),
              ),
            )
          : null,
      body: Column(
        children: [
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        floatingLabelStyle:
                            TextStyle(color: Colors.deepPurpleAccent),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.deepPurpleAccent, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: Text("Search Product"),
                        hintText: "Search By name",
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.deepPurpleAccent,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      onChanged:
                          searchProduct, // Call searchProduct on text change
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: DropdownButtonFormField<String>(
                            value: selectedCategory,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            dropdownColor: Color(0xffeaddff),
                            style: TextStyle(color: Color(0xff301069)),
                            hint: const Text("Category"),
                            items: categories!.map((category) {
                              return DropdownMenuItem<String>(
                                value: category['name'],
                                child: Text(category['name']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory =
                                    value; // Update the selected category
                              });
                              searchProductByCategory(
                                  value!); // Call the method with the selected value
                            },
                            isExpanded: true,
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 6,
                          child: TextFormField(
                            decoration: InputDecoration(
                              floatingLabelStyle:
                                  TextStyle(color: Colors.deepPurpleAccent),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepPurpleAccent, width: 2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              label: Text("Id"),
                              hintText: "Search By Id",
                              suffixIcon: Icon(
                                Icons.search,
                                color: Colors.deepPurpleAccent,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            onChanged:
                                searchProductById, // Call searchProduct on text change
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: filteredProducts != null
                  ? GridView.builder(
                      itemCount: filteredProducts!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        var product = filteredProducts![index];
                        var imageData = base64Decode("${product["image"]}");
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              passProduct(product["id"]);
                            });
                          },
                          child: Card(
                            shape: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: cartItems!.any((cartItem) =>
                                            cartItem['productId'] ==
                                            product['id'])
                                        ? Colors.blue
                                        : Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.memory(
                                      imageData,
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ),
                                Text(
                                  product['name'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
