import 'package:fabiaoqing/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fabiaoqing/utils/validation_utils.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {
  var telephone = "";
  var password = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/bg.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: EdgeInsets.only(top: 150, left: 20, right: 20),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  ClipOval(
                    child: FlutterLogo(
                      size: 64,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      "来发表情吧",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontFamily: "KuaiLe"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                        cursorColor: Colors.red,
                        validator: (value) => validationTextField(
                            "手机号码", value, r"^1[3456789](\d){9}$"),
                        style: TextStyle(fontSize: 14),
                        keyboardType: TextInputType.phone,
                        onChanged: (text) => setState(() => telephone = text),
                        decoration: InputDecoration(
                            hintText: "请输入手机号码",
                            hintStyle: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey[400], width: 1)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1)))),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                        style: TextStyle(fontSize: 14),
                        obscureText: true,
                        cursorColor: Colors.red,
                        validator: (value) => validationTextField("密码", value,
                            r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$"),
                        onChanged: (text) => setState(() => password = text),
                        decoration: InputDecoration(
                            hintText: "请输入密码",
                            hintStyle: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey[400], width: 1)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1)))),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      child: Text(
                        "登录",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _formKey.currentState != null &&
                              _formKey.currentState.validate()
                          ? _onTapLogin
                          : null,
                      disabledColor: Colors.grey[400],
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      minWidth: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      highlightElevation: 0,
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  void _onTapLogin() {
    showDialog(context: context, builder: (context) => new LoadingDialog());
    Future.delayed(Duration(seconds: 5), () => Navigator.pop(context));
  }
}
