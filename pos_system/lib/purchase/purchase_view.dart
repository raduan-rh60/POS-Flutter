import 'package:flutter/material.dart';
import 'package:pos_system/purchase/purchase_data.dart';
import 'package:pos_system/purchase/purchase_form.dart';

class PurchaseView extends StatefulWidget {
  const PurchaseView({super.key});

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Purchase View"),
      ),
      floatingActionButton:SizedBox(
        width: 150,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseForm(),));
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Icon(Icons.add_circle_outline_sharp),
                Text(" Add Purchase")
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: PurchaseData()),
    );
  }
}
