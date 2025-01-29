import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pos_system/orders/order_details.dart';

import '../main.dart';

class ReturnData extends StatefulWidget {
  const ReturnData({super.key});

  @override
  State<ReturnData> createState() => _ReturnDataState();
}

class _ReturnDataState extends State<ReturnData> {
  List<Map<String, dynamic>>? returnsData;

  @override
  void initState() {
    super.initState();
    getGeneralSales();
  }

  getGeneralSales() async {
    var productReturn = await http.get(
      Uri.parse("http://$ip:8080/api/return"),
    );
    var productReturnData = jsonDecode(productReturn.body);

    setState(() {
      returnsData = List<Map<String, dynamic>>.from(productReturnData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return returnsData != null
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Allows horizontal scrolling
            child: DataTable(
              columnSpacing: 20,
              columns: [
                DataColumn(label: Text('Invoice')),
                DataColumn(label: Text('Return Date')),
                DataColumn(label: Text('Return Items')),
                DataColumn(label: Text('Return Amount')),
              ],
              rows: returnsData!.map((productReturns) {
                String orderItemNames =
                    (productReturns['orderId']['orderItems'] as List<dynamic>)
                        .where((item) =>
                            item['returnQuantity'] >=
                            1) // Filter for returnQuantity >= 1
                        .map((item) => item['name']) // Map to item names
                        .join(' , '); // Join names with a comma
                return DataRow(
                  cells: [
                    DataCell(InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetails(
                                    id: productReturns['orderId']['id']),
                              ));
                        },
                        child: Text(
                          "Invoice Id ${productReturns['orderId']['id']}",
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ))),
                    DataCell(Text(productReturns['date'])),
                    DataCell(Text(orderItemNames)),
                    DataCell(Text(productReturns['returnAmount'].toString())),
                  ],
                );
              }).toList(),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
