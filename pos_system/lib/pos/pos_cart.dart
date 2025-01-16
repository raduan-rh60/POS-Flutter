import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PosCart extends StatefulWidget {
  const PosCart({super.key});

  @override
  State<PosCart> createState() => _PosCartState();
}

class _PosCartState extends State<PosCart> {
  String? selectedOrderType;
  String? selectedDeliveryArea;
  String? selectedOrderStatus;
  String? selectedTransactionType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartProducts();
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text("POS Cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  floatingLabelStyle: TextStyle(color: Colors.deepPurpleAccent),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.deepPurpleAccent, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  label: Text("Customer Name"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                value: selectedOrderType,

                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                dropdownColor: Color(0xffeaddff),
                style: TextStyle(color: Color(0xff301069)),
                hint: const Text("Order Type"),
                items: [
                  DropdownMenuItem(
                    value: "GENERAL",
                    child: Text("GENERAL"),
                  ),
                  DropdownMenuItem(
                    value: "ONLINE",
                    child: Text("ONLINE"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedOrderType = value; // Update the selected value
                  });
                },
                isExpanded: true,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  floatingLabelStyle: TextStyle(color: Colors.deepPurpleAccent),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.deepPurpleAccent, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  label: Text("Customer Phone Number"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (selectedOrderType == "ONLINE")
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: DropdownButtonFormField<String>(
                            value: selectedDeliveryArea,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            dropdownColor: Color(0xffeaddff),
                            style: TextStyle(color: Color(0xff301069)),
                            hint: const Text("Delivery"),
                            items: [
                              DropdownMenuItem(
                                value: "Dhaka",
                                child: Text("Dhaka"),
                              ),
                              DropdownMenuItem(
                                value: "Gazipur",
                                child: Text("Gazipur"),
                              ),
                              DropdownMenuItem(
                                value: "Free",
                                child: Text("Free"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedDeliveryArea =
                                    value; // Update the selected category
                              });
                            },
                            isExpanded: true,
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 9,
                          child: DropdownButtonFormField<String>(
                            value: selectedOrderStatus,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            dropdownColor: Color(0xffeaddff),
                            style: TextStyle(color: Color(0xff301069)),
                            hint: const Text("Order Status"),
                            items: [
                              DropdownMenuItem(
                                value: "PROCESS",
                                child: Text("PROCESS"),
                              ),
                              DropdownMenuItem(
                                value: "DELIVERED",
                                child: Text("DELIVERED"),
                              ),
                              DropdownMenuItem(
                                value: "HOLD",
                                child: Text("HOLD"),
                              ),
                              DropdownMenuItem(
                                value: "PICK",
                                child: Text("PICK"),
                              ),
                              DropdownMenuItem(
                                value: "COMPLETE",
                                child: Text("COMPLETE"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedOrderStatus =
                                    value; // Update the selected category
                              });
                            },
                            isExpanded: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        floatingLabelStyle:
                            TextStyle(color: Colors.deepPurpleAccent),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.deepPurpleAccent, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: Text("Delivery Address"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  floatingLabelStyle: TextStyle(color: Colors.deepPurpleAccent),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.deepPurpleAccent, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  label: Text("Note"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              //   Cart Data Table
              if (cartItems != null)
                SingleChildScrollView(
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
                ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: TextFormField(
                      decoration: InputDecoration(
                        floatingLabelStyle: TextStyle(color: Colors.deepPurpleAccent),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.deepPurpleAccent, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: Text("Discount"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 9,
                    child: DropdownButtonFormField<String>(
                      value: selectedTransactionType,

                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      dropdownColor: Color(0xffeaddff),
                      style: TextStyle(color: Color(0xff301069)),
                      hint: const Text("Order Type"),
                      items: [
                        DropdownMenuItem(
                          value: "Cash",
                          child: Text("Cash"),
                        ),
                        DropdownMenuItem(
                          value: "Bkash",
                          child: Text("Bkash"),
                        ),
                        DropdownMenuItem(
                          value: "Nogod",
                          child: Text("Nogod"),
                        ),
                        DropdownMenuItem(
                          value: "Rocket",
                          child: Text("Rocket"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedTransactionType = value; // Update the selected value
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
