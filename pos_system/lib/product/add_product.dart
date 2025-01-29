import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:pos_system/product/products.dart';

import '../main.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productStock = TextEditingController();
  final TextEditingController _purchasePrice = TextEditingController();
  final TextEditingController _salePrice = TextEditingController();

  List<Map<String, dynamic>> categories = []; // Initialize as an empty list
  List<Map<String, dynamic>> brands = []; // Initialize as an empty list

  dynamic selectedCategory;
  dynamic selectedBrands;
  String? base64img;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
    getBrand();
  }

  getCategory() async {
    try {
      var getCategories =
          await http.get(Uri.parse("http://$ip:8080/api/category"));
      if (getCategories.statusCode == 200) {
        var categoryResponse = jsonDecode(getCategories.body);
        setState(() {
          categories = List<Map<String, dynamic>>.from(categoryResponse);
        });
      } else {
        print("Failed to fetch categories");
      }
    } catch (e) {
      print("Failed to fetch categories: $e");
    }
  }

  getBrand() async {
    try {
      var getBrand =
          await http.get(Uri.parse("http://$ip:8080/api/brand"));
      if (getBrand.statusCode == 200) {
        var brandResponse = jsonDecode(getBrand.body);
        setState(() {
          brands = List<Map<String, dynamic>>.from(brandResponse);
        });
      } else {
        print("Failed to fetch Brands");
      }
    } catch (e) {
      print("Failed to fetch Brands: $e");
    }
  }

  Uint8List? _imageBytes; // To store the selected image
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes(); // Read image as bytes
      base64img = base64Encode(imageBytes);
      setState(() {
        _imageBytes = imageBytes;
      });
    }
  }

  addProduct() async {
    if (_formKey.currentState!.validate()) {
      var addProductResponse =
          await http.post(Uri.parse("http://$ip:8080/api/product/save"),
              headers: {
                'Content-Type':
                    'application/json', // Set the Content-Type to JSON
              },
              body: jsonEncode({
                'name': _productName.text,
                'stock': int.parse(_productStock.text),
                'purchasePrice': double.parse(_purchasePrice.text),
                'price': double.parse(_salePrice.text),
                'category': selectedCategory,
                'brand': selectedBrands,
                'image': base64img,
              }));

      if (addProductResponse.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Products()),
        );
      } else {
        print("Something went wrong to post Product");
      }
    } else {
      print("Form is invalid!");
    }
  }

  // making design for all input field
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      floatingLabelStyle: TextStyle(color: Colors.deepPurpleAccent),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      label: Text(label),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _imageBytes != null
                            ? MemoryImage(_imageBytes!)
                            : AssetImage("assets/icons/products.png"),
                      ),
                      Positioned(
                        right: -10,
                        bottom: 0,
                        child: IconButton(
                          onPressed: _pickImage,
                          icon: Icon(Icons.edit),
                          style: ButtonStyle(
                            backgroundColor:WidgetStatePropertyAll(Colors.deepPurpleAccent[100])
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _productName,
                  decoration: _buildInputDecoration("Product Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Product Name is required.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _productStock,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration("Product Stock"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Product Stock is required.";
                    }
                    if (int.tryParse(value) == null) {
                      return "Please enter a valid number.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _purchasePrice,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration("Purchase Price"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Purchase Price is required.";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid number.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _salePrice,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration("Sale Price"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Sale Price is required.";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid number.";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<int>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  dropdownColor: Color(0xffeaddff),
                  style: TextStyle(color: Color(0xff301069)),
                  hint: const Text("Category"),
                  items: categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category['id'],
                      child: Text(category['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value; // Update the selected category
                    });
                  },
                  isExpanded: true,
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<int>(
                  value: selectedBrands,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  dropdownColor: Color(0xffeaddff),
                  style: TextStyle(color: Color(0xff301069)),
                  hint: const Text("Brand"),
                  items: brands.map((brand) {
                    return DropdownMenuItem<int>(
                      value: brand['id'],
                      child: Text(brand['name']),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      selectedBrands = value; // Update the selected category
                    });
                  },
                  isExpanded: true,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Add",style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
