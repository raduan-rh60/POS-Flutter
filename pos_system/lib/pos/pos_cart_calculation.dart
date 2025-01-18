import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartCalculation extends StatefulWidget {
  const CartCalculation({super.key});

  @override
  State<CartCalculation> createState() => _CartCalculationState();
}

class _CartCalculationState extends State<CartCalculation> {
  // cart Data
  List<Map<String, dynamic>>? cartItems;

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


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 40,
        columns: [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Quantity')),
          DataColumn(label: Text('Subtotal')),
          DataColumn(label: Text('Action')),
        ],
        rows: cartItems!.map((cartItem) {
          return DataRow(
            cells: [
              DataCell(Text(cartItem['name'])),
              DataCell(Text(cartItem['price'].toString())),

              DataCell(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (cartItem['quantity'] > 0) {
                          cartItem['quantity']--;
                        }
                      });
                    },
                    icon: Icon(Icons.remove),
                    style: ButtonStyle(shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.deepPurpleAccent))
                    ),
                        foregroundColor: WidgetStatePropertyAll(
                            Colors.deepPurpleAccent
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      cartItem['quantity'].toString(),
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        cartItem['quantity']++;
                      });
                    },
                    icon: Icon(Icons.add),
                    style: ButtonStyle(shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.deepPurpleAccent))
                    ),
                      foregroundColor: WidgetStatePropertyAll(
                          Colors.deepPurpleAccent
                      ),
                    ),
                  ),
                ],
              )),
              DataCell(Text(cartItem['subtotal'].toString())),
              DataCell(IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ))),
            ],
          );
        }).toList(),
      ),
    );
  }
}
