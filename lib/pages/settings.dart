import 'package:fabiaoqing/common/api_result_code.dart';
import 'package:fabiaoqing/common/common_user.dart';
import 'package:fabiaoqing/pages/update_tel.dart';
import 'package:fabiaoqing/utils/alert_utils.dart';
import 'package:fabiaoqing/utils/net_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

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
        if (!CommonUser.getInstance().isLogin()) {
          Toast.show("╮(￣▽￣)╭，还未登录哦", context, gravity: Toast.CENTER);
          return;
        }
        _gotoTel();
        break;
      default:
        break;
    }
  }

  void _gotoTel() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateTelPage(needLogout: _logout)));
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
