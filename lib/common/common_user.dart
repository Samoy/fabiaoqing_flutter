import 'package:fabiaoqing/models/index.dart';
import 'package:fabiaoqing/utils/storage_utils.dart';

class CommonUser {
  LoginResult _loginResult = new LoginResult();
  String _telephone;

  // 工厂模式
  factory CommonUser() => getInstance();

  static CommonUser get instance => getInstance();
  static CommonUser _instance;

  CommonUser._internal() {
    initData();
  }

  //此方法只允许调用一次，也就是在程序入口处调用
  CommonUser.init() {
    if (_instance == null) {
      _instance = CommonUser._internal();
    }
    CommonUser._internal();
  }

  initData() async {
    var userId = await StorageUtils.getItem("userId");
    var token = await StorageUtils.getItem("token");
    var tel = await StorageUtils.getItem("telephone");
    if (userId != null) {
      _loginResult.userId = userId;
    }
    if (token != null) {
      _loginResult.token = token;
    }
    if (tel != null) {
      _telephone = tel;
    }
    return this;
  }

  static CommonUser getInstance() {
    return _instance;
  }

  void setLoginResult(LoginResult loginResult, String telephone) {
    this._loginResult = loginResult;
    this._telephone = telephone;
    StorageUtils.setItem("userId", loginResult.userId);
    StorageUtils.setItem("token", loginResult.token);
    StorageUtils.setItem("telephone", telephone);
  }

  String getToken() {
    return _loginResult.token;
  }

  String getUserId() {
    return _loginResult.userId;
  }

  String getTelephone() {
    return _telephone;
  }

  bool isLogin() {
    return _loginResult.userId != null && _loginResult.token != null;
  }

  void logout() {
    _loginResult.userId = null;
    _loginResult.token = null;
    _telephone = null;
    StorageUtils.removeItem("userId");
    StorageUtils.removeItem("token");
    StorageUtils.removeItem("telephone");
  }

  LoginResult getLoginResult() {
    return this._loginResult;
  }
}
