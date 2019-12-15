import 'package:fabiaoqing/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';

class AlertUtils {
  static Future<void> showAlert(BuildContext context, String title,
      {String message = "", onOK(), bool canCancel = true}) async {
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
                Navigator.pop(context);
                if (onOK != null) {
                  onOK();
                }
              },
            ),
            canCancel
                ? FlatButton(
                    child: Text('取消'),
                    onPressed: () => Navigator.pop(context),
                  )
                : null,
          ],
        );
      },
    );
  }

  static Future<void> showSelectDialog(
      BuildContext context, String title, List<String> dataSource,
      {onSelect(index)}) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text(title),
            children: dataSource
                .map((item) => SimpleDialogOption(
                      child: Text(item),
                      onPressed: () {
                        onSelect(dataSource.indexOf(item));
                        Navigator.pop(ctx);
                      },
                    ))
                .toList(),
          );
        });
  }

  static Future<void> showPrompt(BuildContext context, String title,
      {onOK(text)}) async {
    var _text = "";
    return showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return new AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: Duration(milliseconds: 100),
            child: SingleChildScrollView(
              child: Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 12),
                        child: TextField(
                          onChanged: (text) => _text = text,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: title,
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 13.0),
                              contentPadding: EdgeInsets.all(12),
                              enabledBorder: null,
                              disabledBorder: null),
                        )),
                    Row(
                      children: <Widget>[
                        InkWell(
                          child: Text("确定"),
                          onTap: () {
                            Navigator.pop(ctx);
                            if (onOK != null) {
                              onOK(_text);
                            }
                          },
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          child: InkWell(
                            child: Text("取消"),
                            onTap: () => Navigator.pop(ctx),
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future showLoading(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => LoadingDialog(),
        barrierDismissible: false);
  }
}
