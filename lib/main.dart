// @dart=2.9
import 'package:flutter/material.dart';
import 'package:qr_code/welcome_page.dart';

const d_red = const Color(0xFFE9717D);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sterilize connecté',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
