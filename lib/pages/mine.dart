import 'dart:math';

import 'package:fabiaoqing/common/common_user.dart';
import 'package:fabiaoqing/models/index.dart';
import 'package:fabiaoqing/pages/favorite_page.dart';
import 'package:fabiaoqing/pages/login.dart';
import 'package:fabiaoqing/pages/profile.dart';
import 'package:fabiaoqing/utils/cache_utils.dart';
import 'package:fabiaoqing/utils/net_utils.dart';
import 'package:flutter/material.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MeState();
  }
}

class _MeState extends State {
  final _operationList = [
    {
      "title": "用户反馈",
      "icon": Image.asset("images/feedback.png"),
    },
    {
      "title": "清除缓存",
      "icon": Image.asset("images/cache.png"),
    },
    {
      "title": "夜间模式",
      "icon": Icon(
        Icons.ac_unit,
      ),
    },
    {
      "title": "关于我们",
      "icon": Icon(
        Icons.ac_unit,
      )
    }
  ];

  String _nickname = "未登录用户";
  String _avatarUrl =
      "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1624240531,2195794812&fm=26&gp=0.jpg";

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
        title: Text("我的"),
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
                          child: CacheUtils.cacheNetworkImage(
                            context,
                            _avatarUrl,
                            width: 80.toDouble(),
                            height: 80.toDouble(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 12),
                          child: Column(children: <Widget>[
                            Text(
                              _nickname,
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
            margin: EdgeInsets.only(top: 20),
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
              margin: EdgeInsets.only(top: 19),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    var operation = _operationList[index];
                    Widget rightWidget = Icon(Icons.chevron_right);
                    if (index == 1) {
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
                      onTap: () => _onTapRow(operation, index),
                    );
                  },
                  //separatorBuilder: (context, index) => Divider(),
                  itemCount: _operationList.length),
            ),
          )
        ],
      ),
    );
  }

  void _onTapAvatar() async {
    if (CommonUser.getInstance().isLogin()) {
      var logoutSuccess = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => ProfilePage(_nickname)));
      if (logoutSuccess) {
        setState(() {
          _nickname = "未登录用户";
        });
      }
    } else {
      var loginSuccess = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
      if (loginSuccess) {
        _getProfile();
      }
    }
  }

  void _onTapMyDiy() {}

  void _onTapMyFavorite() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FavoritePage()));
  }

  void _onTapHistory() {}

  void _onTapRow(Map<String, Object> operation, int index) async {
    switch (index) {
      case 1:
        CacheUtils.clearCache(context);
        setState(() {
          _cacheSize = "0.00B";
        });
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
        User currentUser = User.fromJson(res["data"]);
        setState(() {
          _nickname = currentUser.nickname;
          _avatarUrl =
              currentUser.avatar.isEmpty ? _avatarUrl : currentUser.avatar;
        });
      }
    }
  }

  void _getCacheSize() async {
    var size = await CacheUtils.loadCache();
    print("缓存:$size");
    setState(() {
      _cacheSize = size;
    });
  }
}