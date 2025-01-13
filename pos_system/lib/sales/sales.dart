import 'package:flutter/material.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  // Demo data for the table
  List<Map<String, dynamic>> salesData = [
    {
      'id': 1,
      'date': '2025-01-10',
      'items': ['Item 1', 'Item 2'],
      'saleAmount': 250.0,
      'purchaseAmount': 150.0,
    },
    {
      'id': 2,
      'date': '2025-01-11',
      'items': ['Item 3', 'Item 4'],
      'saleAmount': 450.0,
      'purchaseAmount': 300.0,
    },
    {
      'id': 3,
      'date': '2025-01-12',
      'items': ['Item 5', 'Item 6'],
      'saleAmount': 150.0,
      'purchaseAmount': 90.0,
    },
  ];

  void handleAction(String action, int id) {
    // Logic for each action: delete, return, or details
    switch (action) {
      case 'Delete':
        setState(() {
          salesData.removeWhere((element) => element['id'] == id);
        });
        break;
      case 'Return':
      // Implement return logic here
        break;
      case 'Details':
      // Implement details logic here
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('SL (ID)')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Items')),
            DataColumn(label: Text('Sale Amount')),
            DataColumn(label: Text('Purchase Amount')),
            DataColumn(label: Text('Actions')),
          ],
          rows: salesData.map((data) {
            return DataRow(
              cells: [
                DataCell(Text(data['id'].toString())),
                DataCell(Text(data['date'])),
                DataCell(Text(data['items'].join(', '))),
                DataCell(Text(data['saleAmount'].toString())),
                DataCell(Text(data['purchaseAmount'].toString())),
                DataCell(
                  DropdownButton<String>(
                    onChanged: (String? value) {
                      if (value != null) {
                        handleAction(value, data['id']);
                      }
                    },
                    items: <String>['Delete', 'Return', 'Details']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
