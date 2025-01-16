import 'package:flutter/material.dart';

class PosCart extends StatefulWidget {
  const PosCart({super.key});

  @override
  State<PosCart> createState() => _PosCartState();
}

class _PosCartState extends State<PosCart> {
  String? selectedOrderType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("POS Cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.deepPurpleAccent),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.deepPurpleAccent, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                label: Text("Customer Name"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<String>(
              value: selectedOrderType,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
              dropdownColor: Color(0xffeaddff),
              style: TextStyle(color: Color(0xff301069)),
              hint: const Text("Order Type"),
              items: [
                DropdownMenuItem(
                  value: "General",
                  child: Text("General"),
                ),
                DropdownMenuItem(
                  value: "Online",
                  child: Text("Online"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedOrderType = value; // Update the selected category
                });
              },
              isExpanded: true,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.deepPurpleAccent),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.deepPurpleAccent, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                label: Text("Customer Phone Number"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
