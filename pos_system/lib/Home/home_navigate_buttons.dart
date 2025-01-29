import 'package:flutter/material.dart';
import 'package:pos_system/damage/damage_data.dart';
import 'package:pos_system/pos/pos_products.dart';
import 'package:pos_system/product/products.dart';
import 'package:pos_system/purchase/purchase_view.dart';
import 'package:pos_system/return/return_product_view.dart';
import 'package:pos_system/sales/general_sales_view.dart';

class NavigateButton extends StatefulWidget {
  const NavigateButton({super.key});

  @override
  State<NavigateButton> createState() => _NavigateButtonState();
}

class _NavigateButtonState extends State<NavigateButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 400,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 50),
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Products()));
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/icons/products.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Text("Products"),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Sales()));
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/icons/sales.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Text("Sales"),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReturnProductView()));
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/icons/return.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Text("Returns"),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PurchaseView()));
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/icons/purchase.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Text("Purchases"),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DamageData()));
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/icons/damage.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Text("Damages"),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PosProducts()));
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/icons/pos.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Text("POS"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
