import 'package:fabiaoqing/models/index.dart';
import 'package:fabiaoqing/utils/storage_utils.dart';

class CommonUser {
  LoginResult _loginResult = new LoginResult();

  // 工厂模式
  factory CommonUser() => getInstance();

  static CommonUser get instance => getInstance();
  static CommonUser _instance;

  CommonUser._internal() {
    setData();
  }

  //此方法只允许调用一次，也就是在程序入口处调用
  CommonUser.init() {
    if (_instance == null) {
      _instance = CommonUser._internal();
    }
    CommonUser._internal();
  }

  setData() async {
    var userId = await StorageUtils.getItem("userId");
    var token = await StorageUtils.getItem("token");
    if (userId != null) {
      _loginResult.userId = userId;
    }
    if (token != null) {
      _loginResult.token = token;
    }
  }

  static CommonUser getInstance() {
    return _instance;
  }

  void setLoginResult(LoginResult loginResult) {
    this._loginResult = loginResult;
    StorageUtils.setItem("userId", loginResult.userId);
    StorageUtils.setItem("token", loginResult.token);
  }

  String getToken() {
    return _loginResult.token;
  }

  String getUserId() {
    return _loginResult.userId;
  }

  LoginResult getLoginResult() {
    return this._loginResult;
  }
}
