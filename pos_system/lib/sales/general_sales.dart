import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      Uri.parse("http://localhost:8080/api/sale/order-type?orderType=GENERAL"),
    );
    var generalSaleData = jsonDecode(generalSales.body);

    setState(() {
      generalSale = List<Map<String, dynamic>>.from(generalSaleData);
    });
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
                              print('Delete clicked for ID: ${sale['id']}');
                            } else if (value == 'Details') {
                              // Call details logic
                              print('Details clicked for ID: ${sale['id']}');
                            } else if (value == 'Return') {
                              // Call return logic
                              print('Return clicked for ID: ${sale['id']}');
                            }
                          }
                        },
                        items: <String>['Delete', 'Details', 'Return']
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
