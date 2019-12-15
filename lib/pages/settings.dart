import 'package:fabiaoqing/common/api_result_code.dart';
import 'package:fabiaoqing/common/common_user.dart';
import 'package:fabiaoqing/pages/about.dart';
import 'package:fabiaoqing/pages/update_psd.dart';
import 'package:fabiaoqing/pages/update_tel.dart';
import 'package:fabiaoqing/utils/alert_utils.dart';
import 'package:fabiaoqing/utils/net_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'forget_psd.dart';

class SettingsPage extends StatefulWidget {
  final Function onLogoutSuccess;

  const SettingsPage({Key key, this.onLogoutSuccess}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsState(this.onLogoutSuccess);
  }
}

class _SettingsState extends State<SettingsPage> {
  final Function _onLogoutSuccess;

  bool _isLogout = false;

  _SettingsState(this._onLogoutSuccess);

  @override
  Widget build(BuildContext context) {
    const list = ["修改手机号码", "修改密码", "版本更新", "关于"];
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        title: Text("设置"),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: <Widget>[
              Column(
                children: ListTile.divideTiles(
                    context: context,
                    color: Colors.grey,
                    tiles: list.map((item) {
                      return Container(
                        child: ListTile(
                          title: Text(item),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () => _onTapRow(list.indexOf(item)),
                        ),
                        color: Colors.white,
                      );
                    })).toList(),
              ),
              !_isLogout
                  ? Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(16),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text("退出登录"),
                        color: Colors.red,
                        onPressed: _onTapLogout,
                        elevation: 0,
                        textColor: Colors.white,
                        highlightElevation: 0,
                      ),
                    )
                  : Container()
            ],
          )),
    );
  }

  _onTapRow(int index) async {
    switch (index) {
      case 0:
        if (_checkLogin()) {
          _gotoTel();
        }
        break;
      case 1:
        if (_checkLogin()) {
          _checkHasPsd();
        }
        break;
      case 3:
        _gotoAbout();
        break;
      default:
        break;
    }
  }

  bool _checkLogin() {
    if (!CommonUser.getInstance().isLogin()) {
      Toast.show("╮(￣▽￣)╭，还未登录哦", context, gravity: Toast.CENTER);
      return false;
    }
    return true;
  }

  void _gotoTel() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateTelPage(needLogout: _logout)));
  }

  void _checkHasPsd() async {
    AlertUtils.showLoading(context);
    var res = await NetUtils.getInstance(context).get(
        "user/has_psd?userId=${CommonUser.getInstance().getUserId()}",
        headers: {"token": CommonUser.getInstance().getToken()});
    Navigator.pop(context);
    if (res != null && res["data"] != null) {
      if (!res["data"]) {
        AlertUtils.showAlert(context, "您还未设置密码",
            message: "请先初始化密码", canCancel: false, onOK: _gotoSetPsd);
      } else {
        _gotoPsd();
      }
    }
  }

  _gotoSetPsd() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgetPsdPage()));
  }

  void _gotoPsd() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdatePsdPage(
                  needLogout: _logout,
                )));
  }

  void _gotoAbout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AboutPage()));
  }

  void _onTapLogout() {
    AlertUtils.showAlert(context, "确定退出登录?", onOK: _logout);
  }

  _logout() async {
    var res = await NetUtils.getInstance(context).post("user/logout", {
      "userId": CommonUser.getInstance().getUserId(),
    }, headers: {
      "token": CommonUser.getInstance().getToken()
    });
    if (res != null && res["code"] == REQUEST_SUCCESS) {
      Toast.show("o(TωT)o，您已退出登录", context, gravity: Toast.CENTER);
      setState(() {
        _isLogout = true;
      });
      CommonUser.getInstance().logout();
      this._onLogoutSuccess();
    }
  }
}
