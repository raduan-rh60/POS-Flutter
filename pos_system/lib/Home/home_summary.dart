import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeSummary extends StatefulWidget {
  const HomeSummary({super.key});

  @override
  State<HomeSummary> createState() => _HomeSummaryState();
}

class _HomeSummaryState extends State<HomeSummary> {
  double totalSales = 0;
  double totalPurchase = 0;
  double totalProfit = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSales();
    getPurchaseData();
  }

  getSales() async {
    try {
      // Make the HTTP GET request
      final response =
          await http.get(Uri.parse("http://localhost:8080/api/sale"));

      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> data = jsonDecode(response.body);

        // Calculate the total amount using reduce
        setState(() {
          totalSales = data.fold(0.0, (acc, sale) {
            return acc + (sale['totalAmount'] ?? 0.0);
          });
        });
      } else {
        throw Exception('Failed to load sales data');
      }
    } catch (e) {
      throw Exception('Error fetching sales data: $e');
    }
  }

  getPurchaseData() async {
    try {
      // Make the HTTP GET request
      final response =
          await http.get(Uri.parse("http://localhost:8080/api/purchases"));

      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> data = jsonDecode(response.body);

        // Calculate the total `sub_total` using reduce
        setState(() {
          totalPurchase = data.fold(0.0, (acc, purchase) {
            return acc + (purchase['sub_total'] ?? 0.0);
          });
        });
      } else {
        throw Exception('Failed to load purchase data');
      }
    } catch (e) {
      throw Exception('Error fetching purchase data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
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
                    Text("Reports"),
                    // TextButton(
                    //     onPressed: () {}, child: Text("View Detail"))
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    // Total Sales Cart ====================================================
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
                            Text(
                              totalSales.toStringAsFixed(2),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
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
                              child: Icon(Icons.align_vertical_top_rounded),
                            ),
                            Text("profit"),
                            Text(
                              (totalSales - totalPurchase).toStringAsFixed(2),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: (totalSales - totalPurchase) > 0
                                      ? Colors.green
                                      : Colors.red),
                            )
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
                            Text(
                              totalPurchase.toStringAsFixed(2),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
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
