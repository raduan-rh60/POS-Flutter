import 'package:flutter/material.dart';
import 'package:pos_system/sales/general_sales.dart';
import 'package:pos_system/sales/online_sales.dart';

class OnlineSalesView extends StatefulWidget {
  const OnlineSalesView({super.key});

  @override
  State<OnlineSalesView> createState() => _OnlineSalesViewState();
}

class _OnlineSalesViewState extends State<OnlineSalesView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Online Sales"),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical, child: OnlineSales()),
    );
  }
}
