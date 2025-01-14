import 'package:flutter/material.dart';
import 'package:pos_system/sales/general_sales.dart';
import 'package:pos_system/sales/online_sales_view.dart';

import '../Home/home.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("General Sales"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.menu), // Drawer icon
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer(); // Open the drawer
                    },
                  );
                }
            ),
          ),
        ],
      ),
      endDrawer: Align(
        alignment: Alignment.bottomRight,
        child: Drawer(
          // width: MediaQuery.sizeOf(context).width/2,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 60,
              ),
              ListTile(
                leading: Icon(Icons.dashboard_outlined),
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));

                },
              ),
              ListTile(
                leading: Icon(Icons.handshake_outlined),
                title: Text('General sales'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Sales()));

                },
              ),
              ListTile(
                leading: Icon(Icons.add_shopping_cart_outlined),
                title: Text('Categories'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>OnlineSalesView()));
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical, child: GeneralSales()),
    );
  }
}
