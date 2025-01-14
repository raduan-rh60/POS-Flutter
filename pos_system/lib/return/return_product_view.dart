import 'package:flutter/material.dart';
import 'package:pos_system/return/return_data.dart';

class ReturnProductView extends StatefulWidget {
  const ReturnProductView({super.key});

  @override
  State<ReturnProductView> createState() => _ReturnProductViewState();
}

class _ReturnProductViewState extends State<ReturnProductView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Returns"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ReturnData(),
      ),
    );
  }
}
