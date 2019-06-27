import 'package:flutter/material.dart';
import 'package:fabiaoqing/pages/home.dart';
import './pages/detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
