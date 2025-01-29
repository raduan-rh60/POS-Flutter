import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pos_system/orders/order_details.dart';

import '../main.dart';

class GeneralSales extends StatefulWidget {
  const GeneralSales({super.key});

  @override
  _GeneralSalesState createState() => _GeneralSalesState();
}

class _GeneralSalesState extends State<GeneralSales> {
  List<Map<String, dynamic>>? generalSale;

  @override
  void initState() {
    super.initState();
    getGeneralSales();
  }

  getGeneralSales() async {
    var generalSales = await http.get(
      Uri.parse("http://$ip:8080/api/sale/order-type?orderType=GENERAL"),
    );
    var generalSaleData = jsonDecode(generalSales.body);

    setState(() {
      generalSale = List<Map<String, dynamic>>.from(generalSaleData);
    });
  }

  deleteGeneralSale(int id)async{
    final deleteResponse = await http.delete(
      Uri.parse("http://$ip:8080/api/sale/$id"),
    );
    if(deleteResponse.statusCode == 200){
      getGeneralSales();
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
    return generalSale != null
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
              rows: generalSale!.map((sale) {
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
                              deleteGeneralSale(sale['id']);
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
