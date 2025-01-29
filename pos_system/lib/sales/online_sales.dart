import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';
import '../orders/order_details.dart';

class OnlineSales extends StatefulWidget {
  const OnlineSales({super.key});

  @override
  _OnlineSalesState createState() => _OnlineSalesState();
}

class _OnlineSalesState extends State<OnlineSales> {
  List<Map<String, dynamic>>? onlineSale;

  @override
  void initState() {
    super.initState();
    getOnlineSales();
  }

  getOnlineSales() async {
    var onlineSales = await http.get(
      Uri.parse("http://$ip:8080/api/sale/order-type?orderType=ONLINE"),
    );
    var onlineSaleData = jsonDecode(onlineSales.body);

    setState(() {
      onlineSale = List<Map<String, dynamic>>.from(onlineSaleData);
    });
  }
  deleteOnlineSale(int id)async{
    final deleteResponse = await http.delete(
      Uri.parse("http://$ip:8080/api/sale/$id"),
    );
    if(deleteResponse.statusCode == 200){
      getOnlineSales();
      // Show a success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 5,
          content: Text('Item successfully deleted!'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green[300],
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 10, left: 10, right: 10), // Top positioning
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          dismissDirection: DismissDirection.up, // Dismiss upwards

        ),
      );
    }else{
      print("error to delete sale code Status: ${deleteResponse.statusCode}");
    }
  }
  @override
  Widget build(BuildContext context) {
    return onlineSale != null
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Allows horizontal scrolling
            child: DataTable(
              columnSpacing: 20,
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Order Items')),
                DataColumn(label: Text('Sale Amount')),
                DataColumn(label: Text('Action')),
              ],
              rows: onlineSale!.map((sale) {
                String orderItemNames = (sale['orderItems'] as List<dynamic>)
                    .map((item) => item['name'])
                    .join(' , ');
                return DataRow(
                  cells: [
                    DataCell(Text(sale['id'].toString())),
                    DataCell(Text(sale['saleDate'])),
                    DataCell(Text(orderItemNames)),
                    DataCell(Text(sale['totalAmount'].toString())),
                    DataCell(
                      DropdownButton<String>(
                        onChanged: (String? value) {
                          if (value != null) {
                            // Handle actions here
                            if (value == 'Delete') {
                              // Call delete logic
                              deleteOnlineSale(sale['id']);
                            } else if (value == 'Details') {
                              // Call details logic
                              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(id: sale['id']),));
                            }
                          }
                        },
                        items: <String>['Delete', 'Details']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text('Select'),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  void handleAction(String action, int saleId) {
    // Implement your action handling logic here.
    print("Action: $action for Sale ID: $saleId");
  }
}
