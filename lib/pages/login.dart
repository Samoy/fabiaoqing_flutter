import 'package:fabiaoqing/common/common_user.dart';
import 'package:fabiaoqing/models/index.dart';
import 'package:fabiaoqing/pages/login_by_code.dart';
import 'package:fabiaoqing/pages/forget_psd.dart';
import 'package:fabiaoqing/utils/net_utils.dart';
import 'package:fabiaoqing/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fabiaoqing/utils/validation_utils.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  var telephone = "";
  var password = "";

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
                      fontSize: 40, color: Colors.white, fontFamily: "KuaiLe"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: TextField(
                    cursorColor: Colors.red,
                    style: TextStyle(fontSize: 14),
                    keyboardType: TextInputType.number,
                    onChanged: (text) => setState(() => telephone = text),
                    decoration: InputDecoration(
                        hintText: "请输入手机号码",
                        hintStyle:
                            TextStyle(color: Colors.grey[600], fontSize: 14),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[400], width: 1)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1)))),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: TextField(
                    style: TextStyle(fontSize: 14),
                    obscureText: true,
                    cursorColor: Colors.red,
                    onChanged: (text) => setState(() => password = text),
                    decoration: InputDecoration(
                        hintText: "请输入密码",
                        hintStyle:
                            TextStyle(color: Colors.grey[600], fontSize: 14),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[400], width: 1)),
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
                  onPressed: _onTapLogin,
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  minWidth: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  highlightElevation: 0,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Text(
                        "使用验证码",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      onTap: _onTapCodeLogin,
                    ),
                    InkWell(
                      child: Text(
                        "忘记密码？",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      onTap: _onTapForget,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onTapLogin() {
    String telMatch =
        validationTextField("手机号码", telephone, r"^1[3456789](\d){9}$");
    String psdMath = validationTextField(
        "密码", password, r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
    if (telMatch != null) {
      Toast.show(telMatch, context, gravity: Toast.CENTER);
      return;
    }
    if (psdMath != null) {
      Toast.show(psdMath, context, gravity: Toast.CENTER);
      return;
    }
    login();
  }

  void _onTapCodeLogin() async {
    var loginSuccess = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginByCodePage()));
    if (loginSuccess) {
      Navigator.pop(context, true);
    }
  }

  void _onTapForget() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ForgetPsdPage()));
  }

  void login() async {
    showDialog(context: context, builder: (context) => new LoadingDialog());
    var res = await NetUtils.getInstance(context)
        .post("user/login", {"telephone": telephone, "password": password});
    Navigator.pop(context);
    if (res["data"] != null) {
      LoginResult loginResult = LoginResult.fromJson(res["data"]);
      CommonUser.getInstance().setLoginResult(loginResult);
      Navigator.pop(context, true);
    }
  }
}
