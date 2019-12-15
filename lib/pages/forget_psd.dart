import 'package:flutter/material.dart';

class ForgetPsdPage extends StatefulWidget {
  final String title;

  const ForgetPsdPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ForgetPsdState(title);
  }
}

class ForgetPsdState<RegisterPage> extends State {
  final String _title;

  ForgetPsdState(this._title);

  @override
  Widget build(BuildContext context) {
    var inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(width: 0.5, color: Colors.grey[200]));
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text(_title ?? "找回密码")),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  prefixIcon: Icon(
                    Icons.phone_iphone,
                    color: Colors.grey,
                  ),
                  hintText: "请输入手机号",
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder,
                  filled: true,
                  fillColor: Colors.white),
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          prefixIcon: Icon(
                            Icons.verified_user,
                            color: Colors.grey,
                          ),
                          hintText: "请输入验证码",
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                          filled: true,
                          fillColor: Colors.white),
                    ),
                  ),
                  FlatButton(
                    child: Text("获取验证码"),
                    textColor: Colors.red,
                    onPressed: () {},
                  )
                ],
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  hintText: "请设置新的密码",
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder,
                  filled: true,
                  fillColor: Colors.white),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(16),
              child: RaisedButton(
                child: Text("提交"),
                color: Colors.red,
                textColor: Colors.white,
                highlightElevation: 0,
                elevation: 0,
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
