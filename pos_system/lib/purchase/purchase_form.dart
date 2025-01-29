import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pos_system/purchase/purchase_view.dart';

import '../main.dart';

class PurchaseForm extends StatefulWidget {
  const PurchaseForm({super.key});

  @override
  State<PurchaseForm> createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> products =[];
  int ?selectedProductId;
  Map<String, dynamic> ?product;

  int productPrice = 0;


  final TextEditingController _purchaseName = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _purchaseRate = TextEditingController();
  final TextEditingController _totalPurchase = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }




  postPurchase() async{
    if (_formKey.currentState!.validate()) {
      var addDamageResponse =
      await http.post(Uri.parse("http://$ip:8080/api/purchases"),
          headers: {
            'Content-Type':
            'application/json', // Set the Content-Type to JSON
          },
          body: jsonEncode({
            'name': _purchaseName.text,
            'quantity': int.parse(_quantity.text),
            'rate': int.parse(_purchaseRate.text),
            'sub_total': int.parse(_totalPurchase.text),


          }));

      if (addDamageResponse.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PurchaseView()),
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

              TextFormField(
                controller: _purchaseName,
                decoration: _buildInputDecoration("Purchase Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Purchase Name is required.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _purchaseRate,
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration("Product Rate"),

              ),
              SizedBox(height: 10),

              TextFormField(
                controller: _quantity,
                onChanged: (value) {
                  setState(() {
                    _totalPurchase.text = (int.parse(_purchaseRate.text)*int.parse(_quantity.text)).toString();
                  });
                },
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration("Purchase Quantity"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Purchase quantity is required.";
                  }
                  if (int.tryParse(value) == null) {
                    return "Please enter a valid number.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _totalPurchase,
                enabled: false,
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration("Total Purchase Amount"),

              ),
              SizedBox(
                height: 10,
              ),


              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: postPurchase,
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
