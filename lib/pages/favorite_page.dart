import 'package:fabiaoqing/common/api_result_code.dart';
import 'package:fabiaoqing/common/common_user.dart';
import 'package:fabiaoqing/models/emoticon.dart';
import 'package:fabiaoqing/pages/image_preview.dart';
import 'package:fabiaoqing/utils/alert_utils.dart';
import 'package:fabiaoqing/utils/animation_utils.dart';
import 'package:fabiaoqing/utils/cache_utils.dart';
import 'package:fabiaoqing/utils/net_utils.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavoriteState();
  }
}

class _FavoriteState extends State<FavoritePage> {
  var _favoriteList = <Emoticon>[];
  RefreshController _refreshController;
  bool _noData = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var imgWidth = (screenWidth - 8 * 4) / 3;
    var imgHeight = imgWidth;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("我的收藏"),
      ),
      body: SmartRefresher(
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          padding: EdgeInsets.all(8),
          children: _favoriteList
              .map((emoticon) => InkWell(
                    child: CacheUtils.cacheNetworkImage(
                      context,
                      emoticon.url,
                      fit: BoxFit.cover,
                      width: imgWidth,
                      height: imgHeight,
                    ),
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (context, animation, secondAnimation) {
                        return new ImagePreview(
                            currentIndex: _favoriteList.indexOf(emoticon),
                            imageList: _favoriteList);
                      }, transitionsBuilder:
                              (context, animation, secondAnimation, child) {
                        return AnimationUtils.createScaleTransition(
                            animation, child);
                      }));
                    },
                    onLongPress: () {
                      AlertUtils.showAlert(context, "是否删除该表情？",
                          onOK: () => _deleteFavorite(emoticon.objectId));
                    },
                  ))
              .toList(),
        ),
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        footer: ClassicFooter(
          loadingText: "正在加载中...",
          idleText: _noData ? "没有更多了..." : "加载更多...",
          idleIcon:
              _noData ? null : Icon(Icons.arrow_upward, color: Colors.grey),
        ),
      ),
    );
  }

  Future _getFavoriteList() async {
    setState(() {
      _noData = false;
    });
    var res = await NetUtils.getInstance(context).get(
        "favorite/list?userId=${CommonUser.getInstance().getUserId()}&page=$_page&pageSize=10",
        headers: {"token": CommonUser.getInstance().getToken()});
    if (res != null && res["data"] != null) {
      if (res["data"].isEmpty) {
        setState(() {
          _noData = true;
        });
        return;
      }
      for (var value in res["data"]) {
        Emoticon emoticon = Emoticon.fromJson(value);
        setState(() {
          _favoriteList.add(emoticon);
        });
      }
      return;
    }
  }

  void _onRefresh() async {
    _page = 1;
    setState(() => _favoriteList.clear());
    await _getFavoriteList();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _page++;
    await _getFavoriteList();
    _refreshController.loadComplete();
  }

  _deleteFavorite(String emoticonId) async {
    var res = await NetUtils.getInstance(context).post("favorite/delete", {
      "userId": CommonUser.getInstance().getUserId(),
      "emoticonId": emoticonId
    }, headers: {
      "token": CommonUser.getInstance().getToken()
    });
    if (res != null && res["code"] == REQUEST_SUCCESS) {
      Toast.show("(๑•̀ㅂ•́)و✧，删除收藏成功", context, gravity: Toast.CENTER);
      setState(() {
        _favoriteList.remove(
            _favoriteList.firstWhere((it) => it.objectId == emoticonId));
      });
    }
  }
}
