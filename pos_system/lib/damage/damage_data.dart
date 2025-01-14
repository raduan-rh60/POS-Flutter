import 'package:flutter/material.dart';

class DamageData extends StatefulWidget {
  const DamageData({super.key});

  @override
  State<DamageData> createState() => _DamageDataState();
}

class _DamageDataState extends State<DamageData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Damage Data"),
      ),
      body: Placeholder(),
    );
  }
}
