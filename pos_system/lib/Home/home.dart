import 'package:flutter/material.dart';
import 'package:pos_system/Home/home_navigate_buttons.dart';
import 'package:pos_system/Home/home_summary.dart';
import 'package:pos_system/damage/damage_data.dart';
import 'package:pos_system/product/products.dart';
import 'package:pos_system/purchase/purchase_view.dart';
import 'package:pos_system/return/return_product_view.dart';

import '../pos/pos_products.dart';
import '../sales/general_sales_view.dart';
import '../sales/online_sales_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration:
                  BoxDecoration(color: Colors.deepPurpleAccent.shade100),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage("user.jpg"),
                  ),
                  Text(
                    "Raduan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Admin",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('POS Module'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PosProducts()));
              },
            ),
            ListTile(
              leading: Icon(Icons.crop_square_outlined),
              title: Text('Products'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Products()));
              },
            ),
            ListTile(
              leading: Icon(Icons.handshake_outlined),
              title: Text('General sales'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Sales()));
              },
            ),
            ListTile(
              leading: Icon(Icons.add_shopping_cart_outlined),
              title: Text('Online Sales'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OnlineSalesView()));
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_return),
              title: Text('Returns'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReturnProductView()));
              },
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text('Purchase'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PurchaseView()));
              },
            ),
            ListTile(
              leading: Icon(Icons.report_gmailerrorred_outlined),
              title: Text('Damages'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DamageData()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          width: MediaQuery.sizeOf(context).height / 2,
          height: 70,
          margin: EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: Builder(
              builder: (context) => InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Material(
                  borderRadius: BorderRadius.circular(15),
                  elevation: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      "user.jpg",
                      width: 45,
                      height: 45,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              "Raduan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Admin"),
          ),
        ),
        actions: [
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 20),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(50),
          //     color: Color(0x66b274ea),
          //   ),
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.notifications),
          //   ),
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Home Daily Summary Section
            HomeSummary(),
            // Home Icon Button Section
            NavigateButtn(),
          ],
        ),
      ),
    );
  }
}
