import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

import '../main.dart';

class PurchaseData extends StatefulWidget {
  const PurchaseData({super.key});

  @override
  State<PurchaseData> createState() => _PurchaseDataState();
}

class _PurchaseDataState extends State<PurchaseData> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPurchaseData();
  }

  List<Map<String, dynamic>>? purchase;

  getPurchaseData() async {
    var purchaseResponse =
    await http.get(Uri.parse("http://$ip:8080/api/purchases"));
    var purchaseData = jsonDecode(purchaseResponse.body);

    setState(() {
      purchase = List<Map<String, dynamic>>.from(purchaseData);
    });
  }

  @override
  Widget build(BuildContext context) {
  return  purchase != null
        ? SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Allows horizontal scrolling
      child: DataTable(
        columnSpacing: 20,
        columns: [
          DataColumn(label: Text('Id')),
          DataColumn(label: Text('Purchase Date')),
          DataColumn(label: Text('Product Name')),
          DataColumn(label: Text('Product quantity')),
          DataColumn(label: Text('Product rate')),
          DataColumn(label: Text('Purchase Amount')),
        ],
        rows: purchase!.map((purchaseItem) {
          return DataRow(
            cells: [
              DataCell(Text(purchaseItem["id"].toString())),
              DataCell(Text(Jiffy.parse("${DateTime.parse(purchaseItem['date'].toString())}").format(pattern: 'dd/MM/yyyy'))),
              DataCell(Text(purchaseItem['name'])),
              DataCell(Text(purchaseItem['quantity'].toString())),
              DataCell(Text(purchaseItem['rate'].toString())),
              DataCell(Text(purchaseItem['sub_total'].toString())),
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
