import 'package:flutter/material.dart';
import 'package:pos_system/Home/home.dart';

class OrderDetails extends StatelessWidget {
  final int id;
  const OrderDetails({super.key, required this.id});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
      }),
      body: Center(
        child: Text("${id}",style: TextStyle(fontSize: 50),),
      ),
    );
  }
}

