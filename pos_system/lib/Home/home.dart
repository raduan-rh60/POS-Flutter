import 'package:flutter/material.dart';
import 'package:pos_system/Home/home_navigate_buttons.dart';
import 'package:pos_system/Home/home_summary.dart';

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
                    style: TextStyle(fontSize: 18, ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
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
                    child: Image.asset("user.jpg",width: 45,height: 45,),
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0x66b274ea),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Home Daily Summary Section
          HomeSummary(),
          // Home Icon Button Section
          NavigateButtn(),
        ],
      ),
    );
  }
}
