import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fabiaoqing/common/api_result_code.dart';
import 'package:fabiaoqing/common/common_user.dart';
import 'package:fabiaoqing/utils/alert_utils.dart';
import 'package:fabiaoqing/utils/net_utils.dart';
import 'package:fabiaoqing/utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class UpdatePsdPage extends StatefulWidget {
  final Function needLogout;

  const UpdatePsdPage({Key key, this.needLogout}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UpdatePsdState(needLogout);
  }
}

class _UpdatePsdState extends State<UpdatePsdPage> {
  final Function _needLogout;

  String _oldPsd = "";
  String _newPsd = "";

  _UpdatePsdState(this._needLogout);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(width: 1, color: Colors.grey[200]));
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("修改密码"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: TextField(
                onChanged: (text) => setState(() => _oldPsd = text),
                obscureText: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(16),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),
                    hintText: "请输入原密码",
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    filled: true,
                    fillColor: Colors.white),
              ),
            ),
            Container(
              width: double.infinity,
              child: TextField(
                onChanged: (text) => setState(() => _newPsd = text),
                obscureText: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(16),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    hintText: "请输入新密码",
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    filled: true,
                    fillColor: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              width: double.infinity,
              child: RaisedButton(
                child: Text("提交"),
                elevation: 0,
                highlightElevation: 0,
                color: Colors.red,
                textColor: Colors.white,
                onPressed: _submitPsd,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "注：密码应为8~16位字符，且至少需包含字母、数字及特殊字符中的两种",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _submitPsd() {
    if (_oldPsd.isEmpty) {
      Toast.show("原密码不能为空", context, gravity: Toast.CENTER);
      return;
    }
    if (_newPsd.isEmpty) {
      Toast.show("新密码不能为空", context, gravity: Toast.CENTER);
      return;
    }
    String oldPsdMatch = validationTextField("原密码", _oldPsd, PATTERN_PASSWORD);
    String newPsdMatch = validationTextField("新密码", _newPsd, PATTERN_PASSWORD);
    if (oldPsdMatch != null) {
      Toast.show(oldPsdMatch, context, gravity: Toast.CENTER);
      return;
    }
    if (newPsdMatch != null) {
      Toast.show(newPsdMatch, context, gravity: Toast.CENTER);
      return;
    }
    _updatePsd();
  }

  void _updatePsd() async {
    AlertUtils.showLoadingDialog(context);
    var res = await NetUtils.getInstance(context).post("user/update_psd", {
      "userId": CommonUser.getInstance().getUserId(),
      "oldPsd": md5.convert(Utf8Encoder().convert(_oldPsd)),
      "newPsd": md5.convert(Utf8Encoder().convert(_newPsd))
    }, headers: {
      "token": CommonUser.getInstance().getToken()
    });
    Navigator.pop(context);
    if (res != null && res["code"] == REQUEST_SUCCESS) {
      AlertUtils.showAlert(context, "密码修改成功", message: "已退出账号，以后您需要用新密码进行登录",
          onOK: () {
        this._needLogout();
        Navigator.pop(context);
      }, canCancel: false);
    }
  }
}
