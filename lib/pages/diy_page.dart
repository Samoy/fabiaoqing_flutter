import 'package:flutter/material.dart';

class DiyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DiyState();
  }
}

class _DiyState extends State<DiyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("自制表情", style: TextStyle(fontFamily: "KuaiLe")),
        elevation: 0,
      ),
    );
  }
}
