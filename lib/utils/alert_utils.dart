import 'package:flutter/material.dart';

class AlertUtils {
  static Future<void> showAlert(BuildContext context, String title,
      {String message = "", onOK()}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                onOK();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('取消'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
