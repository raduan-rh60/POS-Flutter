import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:pos_system/damage/damage_form.dart';

import '../main.dart';

class DamageData extends StatefulWidget {
  const DamageData({super.key});

  @override
  State<DamageData> createState() => _DamageDataState();
}

class _DamageDataState extends State<DamageData> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }

  List<Map<String, dynamic>>? damages;

  getCategory() async {
    var damageResponse =
    await http.get(Uri.parse("http://$ip:8080/api/damages"));
    var damageData = jsonDecode(damageResponse.body);

    setState(() {
      damages = List<Map<String, dynamic>>.from(damageData);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Damage Data"),
      ),
      floatingActionButton: SizedBox(
        width: 150,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DamageReport(),));
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Icon(Icons.add_circle_outline_sharp),
                Text(" Add Damages")
              ],
            ),
          ),
        ),
      ),
      body: damages != null?
      SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Allows horizontal scrolling
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columnSpacing: 20,
            columns: [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Product Name')),
              DataColumn(label: Text('Report Date')),
              DataColumn(label: Text('Damage Reason')),
              DataColumn(label: Text('Product quantity')),
              DataColumn(label: Text('Product rate')),
              DataColumn(label: Text('Damage Amount')),
            ],
            rows: damages!.map((damageItem) {
              return DataRow(
                cells: [
                  DataCell(Text(damageItem["id"].toString())),
                  DataCell(Text(damageItem["productName"].toString())),
                  DataCell(Text(Jiffy.parse("${DateTime.parse(damageItem['date'].toString())}").format(pattern: 'dd/MM/yyyy'))),
                  DataCell(Text(damageItem['reason'])),
                  DataCell(Text(damageItem['quantity'].toString())),
                  DataCell(Text(damageItem['productPrice'].toString())),
                  DataCell(Text(damageItem['damageAmount'].toString())),
                ],
              );
            }).toList(),
          ),
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      )
      ,
    );
  }
}
