import 'package:fabiaoqing/common/api_result_code.dart';
import 'package:fabiaoqing/common/common_user.dart';
import 'package:fabiaoqing/models/index.dart';
import 'package:fabiaoqing/utils/net_utils.dart';
import 'package:fabiaoqing/utils/validation_utils.dart';
import 'package:fabiaoqing/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:toast/toast.dart';

class LoginByCodePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginByCodeState();
  }
}

class _LoginByCodeState<LoginByCodePage> extends State {
  Timer _timer;
  int _countdownTime = 0;
  var _telephone = "";
  var _code = "";

  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_countdownTime < 1) {
          _timer.cancel();
        } else {
          _countdownTime = _countdownTime - 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("验证码登录"),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => _telephone = value),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "请输入手机号",
                    contentPadding: EdgeInsets.all(12)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 1),
              color: Colors.white,
              padding: EdgeInsets.only(right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() => _code = value),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入验证码",
                          contentPadding: EdgeInsets.all(12)),
                    ),
                  ),
                  FlatButton(
                      child: Text(
                          _countdownTime > 0 ? "${_countdownTime}s" : "获取验证码"),
                      textColor: Colors.deepOrangeAccent,
                      disabledTextColor: Colors.grey,
                      onPressed: _countdownTime > 0
                          ? null
                          : () {
                              String result = validationTextField(
                                  "手机号码", _telephone, r"^1[3456789](\d){9}$");
                              if (result != null) {
                                Toast.show(result, context,
                                    gravity: Toast.CENTER);
                                return null;
                              }
                              return _onTapSendCode();
                            })
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: MaterialButton(
                onPressed: _onTapLoginByCode,
                child: Text(
                  "登录",
                  style: TextStyle(color: Colors.white),
                ),
                disabledColor: Colors.grey[400],
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
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "注：未注册的手机号将会被自动注册",
                style: TextStyle(color: Colors.grey[800]),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onTapSendCode() {
    setState(() {
      _countdownTime = 60;
    });
    startCountdownTimer();
    _sendCode();
  }

  void _sendCode() async {
    var res = await NetUtils.getInstance(context)
        .post("user/send_code", {"telephone": _telephone});
    if (res != null && res["code"] == REQUEST_SUCCESS) {
      Toast.show("验证码发送成功", context, gravity: Toast.CENTER);
    }
  }

  void _onTapLoginByCode() {
    String telMatch =
        validationTextField("手机号码", _telephone, r"^1[3456789](\d){9}$");
    String codeMath = validationTextField("验证码", _code, r"^(\d){6}$");
    if (telMatch != null) {
      Toast.show(telMatch, context, gravity: Toast.CENTER);
      return;
    }
    if (codeMath != null) {
      Toast.show(codeMath, context, gravity: Toast.CENTER);
      return;
    }
    //验证码登录
    loginByCode();
  }

  void loginByCode() async {
    showDialog(context: context, builder: (context) => new LoadingDialog());
    var res = await NetUtils.getInstance(context)
        .post("user/login_by_code", {"telephone": _telephone, "code": _code});
    Navigator.pop(context);
    if (res != null && res["data"] != null) {
      LoginResult loginResult = LoginResult.fromJson(res["data"]);
      CommonUser.getInstance().setLoginResult(loginResult, _telephone);
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
}
