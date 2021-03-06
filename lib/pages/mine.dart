import 'dart:math';

import 'package:fabiaoqing/common/common_user.dart';
import 'package:fabiaoqing/common/constant.dart';
import 'package:fabiaoqing/models/index.dart';
import 'package:fabiaoqing/pages/favorite_page.dart';
import 'package:fabiaoqing/pages/feedback.dart';
import 'package:fabiaoqing/pages/login.dart';
import 'package:fabiaoqing/pages/profile.dart';
import 'package:fabiaoqing/pages/settings.dart';
import 'package:fabiaoqing/utils/cache_utils.dart';
import 'package:fabiaoqing/utils/net_utils.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MeState();
  }
}

class _MeState extends State {
  final _operationList = [
    {
      "title": "我的收藏",
      "icon": Icon(Icons.favorite_border),
      "flag": FLAG_FAVORITE
    },
    {
      "title": "清除缓存",
      "icon": Image.asset(
        "images/cache.png",
        width: 22,
        height: 22,
      ),
      "flag": FLAG_CACHE
    },
    {
      "title": "用户反馈",
      "icon": Image.asset(
        "images/feedback.png",
        width: 22,
        height: 22,
      ),
      "flag": FLAG_FEEDBACK
    },
    {
      "title": "设置",
      "icon": Image.asset(
        "images/settings.png",
        width: 22,
        height: 22,
      ),
      "flag": FLAG_SET
    }
  ];

  User _currentUser;

  String _cacheSize = "0.00B";

  @override
  void initState() {
    super.initState();
    _getProfile();
    _getCacheSize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("我的", style: TextStyle(fontFamily: "KuaiLe")),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ClipOval(
                          child: _currentUser != null &&
                                  _currentUser.avatar.isNotEmpty
                              ? CacheUtils.cacheNetworkImage(
                                  context,
                                  _currentUser.avatar,
                                  width: 80,
                                  height: 80,
                                )
                              : Image.asset(
                                  "images/logo.jpg",
                                  width: 80,
                                  height: 80,
                                ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 12),
                          child: Column(children: <Widget>[
                            Text(
                              _currentUser == null
                                  ? "未登录用户"
                                  : _currentUser.nickname,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "查看并编辑个人资料",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ], crossAxisAlignment: CrossAxisAlignment.start),
                        )
                      ],
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                onTap: _onTapAvatar,
              ),
            ),
          ),
          Container(
            height: 0,
            //todo:我的收藏暂时先放在纵向列表
            //margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "images/diy.jpeg",
                        width: 60,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      Container(
                        child: Text(
                          "我的杰作",
                          textAlign: TextAlign.center,
                        ),
                        margin: EdgeInsets.only(top: 8),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  onTap: _onTapMyDiy,
                ),
                InkWell(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "images/favorite.jpeg",
                        width: 60,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      Container(
                        child: Text(
                          "我的收藏",
                          textAlign: TextAlign.center,
                        ),
                        margin: EdgeInsets.only(top: 8),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  onTap: _onTapMyFavorite,
                ),
                InkWell(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "images/history.jpeg",
                        width: 60,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      Container(
                        child: Text(
                          "历史记录",
                          textAlign: TextAlign.center,
                        ),
                        margin: EdgeInsets.only(top: 8),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  onTap: _onTapHistory,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            color: Colors.white,
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 16),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    var operation = _operationList[index];
                    var flag = operation["flag"];
                    Widget rightWidget = Icon(Icons.chevron_right);
                    if (flag == FLAG_CACHE) {
                      rightWidget = Text(_cacheSize);
                    }
                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(top: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                operation["icon"],
                                Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Text(
                                    operation["title"],
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                )
                              ],
                            ),
                            rightWidget
                          ],
                        ),
                        color: Colors.white,
                      ),
                      onTap: () => _onTapRow(operation),
                    );
                  },
                  itemCount: _operationList.length),
            ),
          )
        ],
      ),
    );
  }

  void _onTapAvatar() async {
    if (CommonUser.getInstance().isLogin()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(
                    _currentUser,
                    onChangeProfile: (User user) {
                      setState(() {
                        _currentUser = user;
                      });
                    },
                  )));
    } else {
      var loginSuccess = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
      if (loginSuccess != null && loginSuccess) {
        _getProfile();
      }
    }
  }

  void _onTapMyDiy() {}

  void _onTapMyFavorite() {
    if (!CommonUser.getInstance().isLogin()) {
      Toast.show("╮(￣▽￣)╭，还未登录哦", context, gravity: Toast.CENTER);
      return;
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FavoritePage()));
  }

  void _onTapHistory() {}

  void _onTapRow(Map<String, Object> operation) async {
    switch (operation["flag"]) {
      case FLAG_FAVORITE:
        _onTapMyFavorite();
        break;
      case FLAG_CACHE:
        CacheUtils.clearCache(context);
        setState(() {
          _cacheSize = "0.00B";
        });
        break;
      case FLAG_FEEDBACK:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FeedbackPage()));
        break;
      case FLAG_SET:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SettingsPage(
                      onLogoutSuccess: () {
                        _currentUser = null;
                      },
                    )));
        break;
      default:
        break;
    }
  }

  void _getProfile() async {
    CommonUser user = await CommonUser.getInstance().initData();
    if (user.isLogin()) {
      var res = await NetUtils.getInstance(context).get(
          "user/profile?userId=${user.getUserId()}",
          headers: {"token": user.getToken()});
      if (res != null && res["data"] != null) {
        setState(() {
          _currentUser = User.fromJson(res["data"]);
        });
      }
    }
  }

  void _getCacheSize() async {
    var size = await CacheUtils.loadCache();
    setState(() {
      _cacheSize = size;
    });
  }
}
