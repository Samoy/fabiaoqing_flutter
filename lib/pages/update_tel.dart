import 'dart:async';

import 'package:fabiaoqing/common/api_result_code.dart';
import 'package:fabiaoqing/common/common_user.dart';
import 'package:fabiaoqing/utils/alert_utils.dart';
import 'package:fabiaoqing/utils/net_utils.dart';
import 'package:fabiaoqing/utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class UpdateTelPage extends StatefulWidget {
  final Function needLogout;

  const UpdateTelPage({Key key, this.needLogout}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UpdateTelPageState(needLogout);
  }
}

class _UpdateTelPageState extends State<UpdateTelPage> {
  String _oldTel = "";
  String _newTel = "";
  String _code = "";
  bool _showCodeWidget = false;
  Timer _timer;
  int _countdownTime = 0;

  final Function _needLogout;

  _UpdateTelPageState(this._needLogout);

  @override
  Widget build(BuildContext context) {
    var inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(width: 1, color: Colors.grey[200]));
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("修改手机号码"),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: <Widget>[
            TextField(
              enabled: !_showCodeWidget,
              onChanged: (text) => setState(() => _oldTel = text),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  prefixIcon: Icon(
                    Icons.phone_android,
                    color: Colors.grey,
                  ),
                  hintText: "请输入原手机号码",
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder,
                  filled: true,
                  fillColor: Colors.white),
            ),
            TextField(
              enabled: !_showCodeWidget,
              onChanged: (text) => setState(() => _newTel = text),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  prefixIcon: Icon(
                    Icons.phone_iphone,
                    color: Colors.grey,
                  ),
                  hintText: "请输入新手机号码",
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder,
                  filled: true,
                  fillColor: Colors.white),
            ),
            Container(
              width: double.infinity,
              child: _showCodeWidget
                  ? Column(
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  onChanged: (text) =>
                                      setState(() => _code = text),
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
                                child: Text(_countdownTime > 0
                                    ? "${_countdownTime}s"
                                    : "重新发送"),
                                textColor: Colors.red,
                                onPressed: _countdownTime > 0
                                    ? null
                                    : () {
                                        String result = validationTextField(
                                            "手机号码", _newTel, PATTERN_PHONE);
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
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(16),
                          child: RaisedButton(
                            child: Text("提交"),
                            color: Colors.red,
                            textColor: Colors.white,
                            highlightElevation: 0,
                            elevation: 0,
                            onPressed: _onSubmit,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "修改手机号码后，您需要通过新手机号码进行登录，且会自动退出原账号",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        )
                      ],
                    )
                  : Container(
                      margin: EdgeInsets.all(16),
                      child: RaisedButton(
                        child: Text("下一步"),
                        color: Colors.red,
                        textColor: Colors.white,
                        highlightElevation: 0,
                        elevation: 0,
                        onPressed: _onTapNext,
                      ),
                    ),
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

  bool validateInput() {
    if (_oldTel.isEmpty) {
      Toast.show("╮(╯▽╰)╭，原手机号码不能为空哦", context, gravity: Toast.CENTER);
      return false;
    }
    if (_oldTel != CommonUser.getInstance().getTelephone()) {
      Toast.show("╮(╯▽╰)╭，原手机号码不正确哦", context, gravity: Toast.CENTER);
      return false;
    }
    if (_newTel.isEmpty) {
      Toast.show("╮(╯▽╰)╭，新手机号码不能为空哦", context, gravity: Toast.CENTER);
      return false;
    }
    RegExp regExp = new RegExp(r"^[1][3456789](\d){9}$");
    if (!regExp.hasMatch(_oldTel)) {
      Toast.show("╮(╯▽╰)╭，原手机号码格式不正确哦", context, gravity: Toast.CENTER);
      return false;
    }

    if (!regExp.hasMatch(_newTel)) {
      Toast.show("╮(╯▽╰)╭，新手机号码格式不正确哦", context, gravity: Toast.CENTER);
      return false;
    }
    return true;
  }

  void _onTapNext() {
    if (validateInput()) {
      _checkNewTel();
    }
  }

  void _checkNewTel() async {
    AlertUtils.showLoading(context);
    var res = await NetUtils.getInstance(context)
        .get("user/find_by_tel?tel=$_newTel");
    Navigator.pop(context);
    if (res != null && res["code"] == REQUEST_SUCCESS) {
      AlertUtils.showAlert(context, "提示", message: "点击\"确定\"填写向您新手机发送的验证码",
          onOK: () {
        _onTapSendCode();
        setState(() {
          _showCodeWidget = true;
        });
      });
    }
  }

  void _onTapSendCode() {
    setState(() {
      _countdownTime = 60;
    });
    startCountdownTimer();
    //_sendCode();
  }

  void _sendCode() async {
    var res = await NetUtils.getInstance(context)
        .post("user/send_code", {"telephone": _newTel});
    if (res != null && res["code"] == REQUEST_SUCCESS) {
      Toast.show("验证码发送成功", context, gravity: Toast.CENTER);
    }
  }

  void _onSubmit() async {
    if (_code.isEmpty) {
      Toast.show("(✺ω✺)，验证码不能为空哦", context, gravity: Toast.CENTER);
      return;
    }
    String codeMatch = validationTextField("验证码", _code, PATTERN_CODE);
    if (codeMatch != null) {
      Toast.show(codeMatch, context, gravity: Toast.CENTER);
      return;
    }
    AlertUtils.showLoading(context);
    var res = await NetUtils.getInstance(context).post("user/update_tel", {
      "userId": CommonUser.getInstance().getUserId(),
      "oldTel": _oldTel,
      "newTel": _newTel,
      "code": _code
    }, headers: {
      "token": CommonUser.getInstance().getToken()
    });
    Navigator.pop(context);
    if (res != null && res["code"] == REQUEST_SUCCESS) {
      AlertUtils.showAlert(context, "手机号码修改成功", message: "已退出账号，以后您需要用新手机号进行登录",
          onOK: () {
        this._needLogout();
        Navigator.pop(context);
      }, canCancel: false);
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
