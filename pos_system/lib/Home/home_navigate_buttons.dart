import 'package:flutter/material.dart';
import 'package:pos_system/product/products.dart';

class NavigateButtn extends StatefulWidget {
  const NavigateButtn({super.key});

  @override
  State<NavigateButtn> createState() => _NavigateButtnState();
}

class _NavigateButtnState extends State<NavigateButtn> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: GridView(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 90, crossAxisSpacing: 5, mainAxisSpacing: 10),
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Products()));
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.lightBlueAccent.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "icons/products.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Text("Products"),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.lightBlueAccent.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "icons/products.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Text("Products"),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.lightBlueAccent.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "icons/products.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Text("Products"),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.lightBlueAccent.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "icons/products.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Text("Products"),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.lightBlueAccent.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "icons/products.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Text("Products"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
