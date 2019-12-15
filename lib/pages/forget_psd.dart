import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fabiaoqing/common/api_result_code.dart';
import 'package:fabiaoqing/common/common_user.dart';
import 'package:fabiaoqing/utils/alert_utils.dart';
import 'package:fabiaoqing/utils/net_utils.dart';
import 'package:fabiaoqing/utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ForgetPsdPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ForgetPsdState();
  }
}

class ForgetPsdState<RegisterPage> extends State {
  String _tel = "";
  String _code = "";
  String _psd = "";

  Timer _timer;
  int _countdownTime = 0;

  @override
  Widget build(BuildContext context) {
    var inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(width: 0.5, color: Colors.grey[200]));
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text("初始化密码")),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (text) => setState(() => _tel = text),
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
                      onChanged: (text) => setState(() => _code = text),
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
                    child: Text(
                        _countdownTime > 0 ? "${_countdownTime}s" : "获取验证码"),
                    textColor: Colors.red,
                    onPressed: _countdownTime > 0
                        ? null
                        : () {
                            String result = validationTextField(
                                "手机号码", _tel, PATTERN_PHONE);
                            if (result != null) {
                              Toast.show(result, context,
                                  gravity: Toast.CENTER);
                              return null;
                            }
                            return _onTapSendCode();
                          },
                  )
                ],
              ),
            ),
            TextField(
              onChanged: (text) => setState(() => _psd = text),
              obscureText: true,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  hintText: "请设置新密码",
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
                onPressed: _onTapSubmit,
              ),
            ),
            Text(
              "注：密码应为8~16位字符，且至少需包含字母、数字及特殊字符中的两种",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

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

  void _onTapSendCode() {
    String tel = CommonUser.getInstance().getTelephone();
    print("手机号:$tel");
    if (tel != null) {
      if (_tel != tel) {
        AlertUtils.showAlert(context, "手机号码不正确",
            message: "请输入您账号所绑定的手机号码", canCancel: false);
        return;
      }
    }
    setState(() {
      _countdownTime = 60;
    });
    startCountdownTimer();
    _sendCode();
  }

  void _sendCode() async {
    var res = await NetUtils.getInstance(context)
        .post("user/send_code", {"telephone": _tel});
    if (res != null && res["code"] == REQUEST_SUCCESS) {
      Toast.show("验证码发送成功", context, gravity: Toast.CENTER);
    }
  }

  void _onTapSubmit() {
    if (_tel.isEmpty) {
      Toast.show("手机号不能为空", context, gravity: Toast.CENTER);
      return;
    }
    if (_code.isEmpty) {
      Toast.show("验证码不能为空", context, gravity: Toast.CENTER);
      return;
    }
    if (_psd.isEmpty) {
      Toast.show("密码不能为空", context, gravity: Toast.CENTER);
      return;
    }
    String telMatch = validationTextField("手机号码", _tel, PATTERN_PHONE);
    String codeMatch = validationTextField("验证码", _code, PATTERN_CODE);
    if (telMatch != null) {
      Toast.show(telMatch, context, gravity: Toast.CENTER);
      return;
    }
    if (codeMatch != null) {
      Toast.show(codeMatch, context, gravity: Toast.CENTER);
      return;
    }
    _initPsdByCode();
  }

  void _initPsdByCode() async {
    AlertUtils.showLoading(context);
    var res = await NetUtils.getInstance(context).post("user/reset_psd",
        {"telephone": _tel, "code": _code, "password": md5.convert(Utf8Encoder().convert(_psd))});
    Navigator.pop(context);
    if (res != null && res["code"] == REQUEST_SUCCESS) {
      Toast.show(res["message"], context, gravity: Toast.CENTER);
      Navigator.pop(context);
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
