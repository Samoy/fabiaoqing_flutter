import 'package:flutter/material.dart';

class UpdateTelPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UpdateTelPageState();
  }
}

class _UpdateTelPageState extends State<UpdateTelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("修改手机号码"),
        elevation: 0,
      ),
      body: Container(
        child: Column(

        ),
      ),
    );
  }
}
