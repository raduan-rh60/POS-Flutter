import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:pos_system/Home/home.dart';
import 'package:pos_system/Login/login.dart';

String ip = '192.168.1.246';
// String ip = '192.168.0.103';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "POS Application",

      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      home: Home(),
    );
  }
}
