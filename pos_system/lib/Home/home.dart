import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: SizedBox(
          width: MediaQuery.sizeOf(context).height / 2,
          height: 60,
          child: ListTile(
            leading: InkWell(
              onTap: (){},
              child: Material(
                borderRadius: BorderRadius.circular(15),
                elevation: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset("user.jpg"),
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
          HomeSummary(),
          // Expanded(
          //     flex: 4,
          //     child: Card(
          //       margin: EdgeInsets.all(10),
          //       color: Colors.blue.shade50,
          //       child: Column(
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.only(
          //               left: 20,
          //               right: 10,
          //               top: 10,
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Text("Today Report"),
          //                 TextButton(
          //                     onPressed: () {}, child: Text("View Detail"))
          //               ],
          //             ),
          //           ),
          //           Row(
          //             children: [
          //               Expanded(
          //                 flex: 4,
          //                 child: Card(
          //                   color: Colors.lightBlueAccent.shade100,
          //                   margin: EdgeInsets.all(10),
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(15.0),
          //                     child: Column(
          //                       children: [
          //                         CircleAvatar(
          //                           child: Icon(Icons.discount_outlined),
          //                         ),
          //                         Text("sales"),
          //                         Text("20,000 TK")
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               Expanded(
          //                 flex: 4,
          //                 child: Card(
          //                   color: Colors.yellowAccent[100],
          //                   margin: EdgeInsets.all(10),
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(15.0),
          //                     child: Column(
          //                       children: [
          //                         CircleAvatar(
          //                           child:
          //                               Icon(Icons.align_vertical_top_rounded),
          //                         ),
          //                         Text("sales"),
          //                         Text("20,000 TK")
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               Expanded(
          //                 flex: 4,
          //                 child: Card(
          //                   color: Colors.redAccent[100],
          //                   margin: EdgeInsets.all(10),
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(15.0),
          //                     child: Column(
          //                       children: [
          //                         CircleAvatar(
          //                           child: Icon(Icons.money),
          //                         ),
          //                         Text("Expenses"),
          //                         Text("20,000 TK")
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           )
          //         ],
          //       ),
          //     )),
          Expanded(
            flex: 10,
            child: GridView(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            children: [

            ],
            ),
          )
        ],
      ),
    );
  }
}
