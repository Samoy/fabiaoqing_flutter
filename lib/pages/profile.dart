import 'package:fabiaoqing/common/common_user.dart';
import 'package:fabiaoqing/utils/alert_utils.dart';
import 'package:fabiaoqing/utils/net_utils.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String name;

  @override
  State<StatefulWidget> createState() {
    return _ProfileState(this.name);
  }

  ProfilePage(this.name);
}

class _ProfileState extends State<ProfilePage> {
  final String _username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(_username),
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text("退出登录"),
            onPressed: _onTapLogout,
          ),
        ),
      ),
    );
  }

  _ProfileState(this._username);

  void _onTapLogout() {
    AlertUtils.showAlert(context, "确定退出登录?", onOK: _logout);
  }

  _logout() async {
    var res = await NetUtils.getInstance(context).post("user/logout", {
      "userId": CommonUser.getInstance().getUserId(),
    }, headers: {
      "token": CommonUser.getInstance().getToken()
    });
    if (res != null && res["code"] == 10000) {
      CommonUser.getInstance().logout();
      Navigator.pop(context, true);
    }
  }
}
