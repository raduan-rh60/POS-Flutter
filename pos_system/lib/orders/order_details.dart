import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../pos/pos_products.dart';

class OrderDetails extends StatefulWidget {
  final int id;

  OrderDetails({super.key, required this.id});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Map<String, dynamic> orderData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderData();
  }

  getOrderData() async {
    try {
      var orderResponse = await http
          .get(Uri.parse("http://localhost:8080/api/sale/${widget.id}"));
      if (orderResponse.statusCode == 200) {
        var data = jsonDecode(orderResponse.body);
        setState(() {
          orderData = Map<String, dynamic>.from(data);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: orderData.isNotEmpty
              ? SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Invoice Number: "),
                          SizedBox(
                            width: 10,
                          ),
                          Text(orderData['id'].toString()),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Customer Name: "),
                          SizedBox(
                            width: 10,
                          ),
                          Text(orderData['customerName'].toString()),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Customer Address: "),
                          SizedBox(
                            width: 10,
                          ),
                          Text(orderData['customerAddress'].toString()),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Sale Date
                      Row(
                        children: [
                          Text("Sale Date: "),
                          SizedBox(width: 10),
                          Text(orderData['saleDate'].toString()),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Sale Time
                      Row(
                        children: [
                          Text("Sale Time: "),
                          SizedBox(width: 10),
                          Text(orderData['saleTime'].toString()),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Customer Phone
                      Row(
                        children: [
                          Text("Customer Phone: "),
                          SizedBox(width: 10),
                          Text(orderData['customerPhone'].toString()),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Total Amount
                      Row(
                        children: [
                          Text("Total Amount: "),
                          SizedBox(width: 10),
                          Text(orderData['totalAmount'].toString()),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Discount
                      Row(
                        children: [
                          Text("Discount: "),
                          SizedBox(width: 10),
                          Text(orderData['discount'].toString()),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Note
                      Row(
                        children: [
                          Text("Note: "),
                          SizedBox(width: 10),
                          Text(orderData['note'].toString()),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Transaction Type
                      Row(
                        children: [
                          Text("Transaction Type: "),
                          SizedBox(width: 10),
                          Text(orderData['transactionType'].toString()),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Total Purchase Price
                      Row(
                        children: [
                          Text("Total Purchase Price: "),
                          SizedBox(width: 10),
                          Text(orderData['totalPurchasePrice'].toString()),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Order Type
                      Row(
                        children: [
                          Text("Order Type: "),
                          SizedBox(width: 10),
                          Text(orderData['orderType'].toString()),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Order Status
                      Row(
                        children: [
                          Text("Order Status: "),
                          SizedBox(width: 10),
                          Text(orderData['orderStatus'].toString()),
                        ],
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          "Order Items",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          itemCount: orderData['orderItems'].length,
                          itemBuilder: (context, index) {
                            var items = orderData['orderItems'][index];
                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.all(8),
                              child: ListTile(
                                leading: Text(
                                  items["name"],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  children: [
                                    Text("Quantity: ${items["quantity"]}"),
                                    Text("Price: ${items['price']}"),
                                  ],
                                ),
                                trailing: Text(
                                  "${items['subtotal']}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (orderData['returnId'] != null)
                        Column(
                          children: [
                            Divider(),
                            Center(
                              child: Text(
                                "Return Items",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount: orderData['orderItems'].length,
                                itemBuilder: (context, index) {
                                  var items = orderData['orderItems'][index];
                                  if (items['returnQuantity'] > 0) {
                                    return Card(
                                      color: Colors.red[200],
                                      elevation: 4,
                                      margin: EdgeInsets.all(8),
                                      child: ListTile(
                                        leading: Text(
                                          items["name"],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          children: [
                                            Text(
                                                "Quantity: ${items["returnQuantity"]}"),
                                            Text("Price: ${items['price']}"),
                                          ],
                                        ),
                                        trailing: Text(
                                          "${items['returnQuantity'] * items['price']}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      Card(
                        margin: EdgeInsets.all(15),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Total Amount: ",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    orderData['totalAmount'].toString(),
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                              if (orderData['returnId'] != null)
                                Row(
                                  children: [
                                    Text(
                                      "Total return amount: ",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      orderData['returnId']['returnAmount']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PosProducts(),
                                  ));
                            },
                            style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side:
                                      BorderSide(color: Colors.green, width: 2),
                                )),
                                backgroundColor: WidgetStatePropertyAll(
                                    Colors.greenAccent[100])),
                            child: Center(
                              child: Text(
                                "POS Module",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
