import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pos_system/damage/damage_data.dart';

import '../main.dart';


class DamageReport extends StatefulWidget {
  const DamageReport({super.key});

  @override
  State<DamageReport> createState() => _DamageReportState();
}

class _DamageReportState extends State<DamageReport> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> products =[];
  int ?selectedProductId;
  Map<String, dynamic> ?product;

  int productPrice = 0;


  final TextEditingController _damageReason = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _productPrice = TextEditingController();
  final TextEditingController _damageAmount = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductData();
  }

  getProductData() async {
    var productsResponse =
    await http.get(Uri.parse("http://$ip:8080/api/product"));
    var productData = jsonDecode(productsResponse.body);

    setState(() {
      products = List<Map<String, dynamic>>.from(productData);
    });
  }

  onSelectProduct(int id) async{
    var productsResponse =
    await http.get(Uri.parse("http://$ip:8080/api/product/$id"));
    var productData = jsonDecode(productsResponse.body);

    setState(() {
      product = Map<String, dynamic>.from(productData);
      _productPrice.text = product!['purchasePrice'].toString();


      print('${product!['purchasePrice']}');

    });
  }

  postDamage() async{
    if (_formKey.currentState!.validate()) {
      var addDamageResponse =
      await http.post(Uri.parse("http://$ip:8080/api/damages/createOrUpdate"),
          headers: {
            'Content-Type':
            'application/json', // Set the Content-Type to JSON
          },
          body: jsonEncode({
            'productId': product!['id'],
            'productName': product!['name'],
            'reason': _damageReason.text,
            'quantity': int.parse(_quantity.text),
            'productPrice': int.parse(_productPrice.text),
            'damageAmount': int.parse(_damageAmount.text),
            
          }));

      if (addDamageResponse.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DamageData()),
        );
      } else {
        print("Something went wrong to post Damage");
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
        title: Text("Damage Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: selectedProductId,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                dropdownColor: Color(0xffeaddff),
                style: TextStyle(color: Color(0xff301069)),
                hint: const Text("Select Product"),
                items: products.map((product) {
                  return DropdownMenuItem<int>(
                    value: product['id'],
                    child: Text(product['name']),
                  );
                }).toList(),
                onChanged: (int? value) {
                  setState(() {
                    selectedProductId = value!; // Update the selected category
                    onSelectProduct(value);
                  });
                },
                isExpanded: true,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _damageReason,
                decoration: _buildInputDecoration("Damage Reason"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Damage Reason is required.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _quantity,
                onChanged: (value){
                  setState(() {
                    _damageAmount.text = (product!['purchasePrice']* int.parse(value)).toString();
                  });
                },
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration("Damage Quantity"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Damage quantity is required.";
                  }
                  if (int.tryParse(value) == null) {
                    return "Please enter a valid number.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                enabled: false,
                controller: _productPrice,
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration("Product Price"),

              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _damageAmount,
                enabled: false,
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration("Damage Amount"),

              ),
              SizedBox(
                height: 10,
              ),


              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: postDamage,
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
    );
  }
}
