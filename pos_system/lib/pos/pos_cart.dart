import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pos_system/orders/order_details.dart';

class PosCart extends StatefulWidget {
  const PosCart({super.key});

  @override
  State<PosCart> createState() => _PosCartState();
}

class _PosCartState extends State<PosCart> {
  // Controllers for TextFormFields
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerPhoneController = TextEditingController();
  final TextEditingController deliveryAddressController =
      TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  // Variables for DropdownButtonFormField
  String? selectedOrderType;
  String selectedDeliveryArea = "Free";
  String selectedOrderStatus = "COMPLETE";
  String? selectedTransactionType;

  // variables for calculation
  int discount = 0;
  double total = 0.0;
  int deliveryCharge = 0;
  double finalTotal = 0;
  int totalQuantity = 0;
  double totalPurchasePrice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartProducts();
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    customerNameController.dispose();
    customerPhoneController.dispose();
    deliveryAddressController.dispose();
    noteController.dispose();
    discountController.dispose();
    super.dispose();
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
        total = 0;
        totalQuantity = 0;
        totalPurchasePrice = 0;
        for (var item in cartItems!) {
          total += item['subtotal'];
          totalQuantity += item['quantity'] as int;
          totalPurchasePrice += item['subTotalPurchasePrice'];
        }
        finalTotalCalculate();
      });
    } else {
      print("Failed to fetch cart products");
    }
  }

  deleteCartProduct(int id) async {
    var cartResponse =
        await http.delete(Uri.parse("http://localhost:8080/api/cart/$id"));
    if (cartResponse.statusCode == 200) {
      setState(() {
        getCartProducts();
      });
    } else {
      print("Failed to fetch cart products");
    }
  }

  updateCart(int cartId,int cartQuantity) async {
    try {
      var updateResponse =
          await http.put(Uri.parse("http://localhost:8080/api/cart/edit"),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'id': cartId,
                'quantity': cartQuantity,
              }));

      if (updateResponse.statusCode == 200) {
        await getCartProducts();
        setState(() {
          finalTotalCalculate();
        });
      } else {
        print("Something went wrong to update cart");
      }
    } catch (e) {
      print(e);
    }
  }

  finalTotalCalculate() {
    finalTotal = total - ((total * discount) / 100) + deliveryCharge;
  }

  // POP up dialogue for the payment confirmation ======================================
  void showOrderDialog(BuildContext context) {
    // Calculate total quantity

    // dialogue for confirm order
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Center(child: Text("Order Summary")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Paying Item:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(totalQuantity.toString()),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Amount:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(total.toStringAsFixed(2)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Net Total Amount:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(finalTotal.toStringAsFixed(2)),
                ],
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  placeOrder();
                },
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.green, width: 2),
                    )),
                    backgroundColor:
                    WidgetStatePropertyAll(Colors.greenAccent)),
                child: Center(
                  child: Text(
                    "Confirm",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // place Order Method
  placeOrder() async {
   try{
     var placeOrderResponse = await http
         .post(Uri.parse("http://localhost:8080/api/sale/save"), headers: {
       'Content-Type': 'application/json', // Set the Content-Type to JSON
     }, body: jsonEncode({
                'customerName': customerNameController.text,
                'customerAddress': deliveryAddressController.text,
                'customerPhone': customerPhoneController.text,
                'note': noteController.text,
                'discount': discount,
                'totalAmount': finalTotal,
                'orderType': selectedOrderType.toString(),
                'orderStatus': selectedOrderStatus.toString(),
                'transactionType': selectedTransactionType.toString(),
                'totalPurchasePrice': totalPurchasePrice,
              }));

     if (placeOrderResponse.statusCode == 200) {
       clearCart();
       var orderData = jsonDecode(placeOrderResponse.body);
       Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(id: orderData['id'],),));

     } else {

       print("Something went wrong to post Product");
     }
   }catch(e){
     print(e);
   }
  }

  clearCart()async{
    final clearCart = await http.patch(
      Uri.parse("http://localhost:8080/api/cart/status?cartStatus=ORDERED"),
      headers: {
        'Content-Type': 'application/json', // Optional, depending on API
      },
      body: jsonEncode({}), // Empty body
    );
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
              // Customer Name Field with controller
              TextFormField(
                controller: customerNameController, // Added controller
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
              // Order Type Dropdown with variable
              DropdownButtonFormField<String>(
                value: selectedOrderType,
                // Added variable
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
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
                    selectedOrderType = value; // Added variable
                  });
                },
                isExpanded: true,
              ),
              SizedBox(
                height: 10,
              ),
              // Customer Phone Number Field with controller
              TextFormField(
                controller: customerPhoneController, // Added controller
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
              // Delivery Area and Order Status Dropdown (if ONLINE is selected)
              if (selectedOrderType == "ONLINE")
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: DropdownButtonFormField<String>(
                            value: selectedDeliveryArea,
                            // Added variable
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
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
                                selectedDeliveryArea = value!; // Added variable
                                if (value == "Dhaka") {
                                  deliveryCharge = 70;
                                } else if (value == "Gazipur") {
                                  deliveryCharge = 100;
                                } else if (value == "Free") {
                                  deliveryCharge = 0;
                                }
                                finalTotalCalculate();
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
                            // Added variable
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
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
                                selectedOrderStatus = value!; // Added variable
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
                      controller: deliveryAddressController, // Added controller
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
              // Note Field with controller
              TextFormField(
                controller: noteController, // Added controller
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
              //   Cart Data Table======================================================
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
                                    if (cartItem['quantity'] > 1) {
                                      updateCart(
                                        cartItem['id'],
                                        cartItem['quantity'] - 1,
                                      );
                                    }
                                  });
                                },
                                icon: Icon(Icons.remove),
                                style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                color:
                                                    Colors.deepPurpleAccent))),
                                    foregroundColor: WidgetStatePropertyAll(
                                        Colors.deepPurpleAccent)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  cartItem['quantity'].toString(),
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    updateCart(
                                      cartItem['id'],
                                      cartItem['quantity'] + 1,
                                    );
                                  });
                                },
                                icon: Icon(Icons.add),
                                style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              color: Colors.deepPurpleAccent))),
                                  foregroundColor: WidgetStatePropertyAll(
                                      Colors.deepPurpleAccent),
                                ),
                              ),
                            ],
                          )),
                          DataCell(Text(cartItem['subtotal'].toString())),
                          DataCell(IconButton(
                              onPressed: () {
                                deleteCartProduct(cartItem['id']);
                              },
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
                      controller: discountController,
                      decoration: InputDecoration(
                        floatingLabelStyle:
                            TextStyle(color: Colors.deepPurpleAccent),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.deepPurpleAccent, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: Text("Discount %"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          discount = int.parse(value);
                          finalTotalCalculate();
                        });
                      },
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
                      hint: const Text("Payment Type"),
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
                          selectedTransactionType =
                              value; // Update the selected value
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 40, // Space between columns
                  columns: [
                    DataColumn(label: Text('Total')),
                    DataColumn(label: Text('Discount %')),
                    DataColumn(label: Text('Delivery Charge')),
                    DataColumn(label: Text('Net Total')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text(total.toStringAsFixed(2))),
                      DataCell(Text(discount.toString())),
                      DataCell(Text(deliveryCharge.toString())),
                      DataCell(Text(finalTotal.toStringAsFixed(2))),
                    ]),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.fromBorderSide(
                        BorderSide(width: 2, color: Colors.blue)),
                  ),
                  child: Center(
                    child: Text(
                      "Grand Total : ${finalTotal.toStringAsFixed(2)} TK",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    showOrderDialog(context);
                  },
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.green, width: 2),
                      )),
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.greenAccent[100])),
                  child: Center(
                    child: Text(
                      "Place Order",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
