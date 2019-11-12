import 'package:flutter/material.dart';

class LoadingDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return new Material(
      type: MaterialType.transparency,
      child: new Center(
        child: new Container(
          decoration: new ShapeDecoration(
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.all(new Radius.circular(10)))),
          width: 100,
          height: 100,
          padding: EdgeInsets.all(10),
          child: Image.asset(
            "images/loading.gif",
            width: 80,
            height: 80,
          ),
        ),
      ),
    );
  }
}
