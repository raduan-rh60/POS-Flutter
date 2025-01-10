import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeSummary extends StatefulWidget {
  const HomeSummary({super.key});

  @override
  State<HomeSummary> createState() => _HomeSummaryState();
}

class _HomeSummaryState extends State<HomeSummary> {
  @override
  Widget build(BuildContext context) {
    return  Expanded(
        flex: 4,
        child: Card(
          margin: EdgeInsets.all(10),
          color: Colors.blue.shade50,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 10,
                  top: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Today Report"),
                    TextButton(
                        onPressed: () {}, child: Text("View Detail"))
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Card(
                      color: Colors.lightBlueAccent.shade100,
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              child: Icon(Icons.discount_outlined),
                            ),
                            Text("sales"),
                            Text("20,000 TK")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Card(
                      color: Colors.yellowAccent[100],
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              child:
                              Icon(Icons.align_vertical_top_rounded),
                            ),
                            Text("sales"),
                            Text("20,000 TK")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Card(
                      color: Colors.redAccent[100],
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              child: Icon(Icons.money),
                            ),
                            Text("Expenses"),
                            Text("20,000 TK")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
