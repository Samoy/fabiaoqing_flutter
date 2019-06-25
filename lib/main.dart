import 'package:flutter/material.dart';
import 'package:fabiaoqing/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.pinkAccent,
      ),
      home: new HomePage(),
    );
  }
}
