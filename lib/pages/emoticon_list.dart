import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/emoticon.dart';
import '../pages/package_detail.dart';
import '../utils/net_utils.dart';
import '../utils/animation_utils.dart';
import 'package:fabiaoqing/pages/image_preview.dart';

class EmoticonList extends StatefulWidget {
  final String keyword;

  const EmoticonList({Key key, @required this.keyword}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new EmoticonListState(keyword);
  }
}

class EmoticonListState extends State<EmoticonList>
    with AutomaticKeepAliveClientMixin {
  final String keyword;
  List<Emoticon> _emoticonList = [];
  RefreshController _refreshController;
  var _page = 1;
  bool _noData = false;

  EmoticonListState(this.keyword);

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
  }

  Future _getEmoticonList(String keyword, int page) async {
    setState(() {
      _noData = false;
    });
    var res = await NetUtils.getInstance(context)
        .get("emoticon/search?keyword=$keyword&page=$page");
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
          _emoticonList.add(emoticon);
        });
      }
    }
  }

  _gotoDetail(BuildContext context, package) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new DetailPage(package.objectId, package.name),
      ),
    );
  }

  void _onRefresh() async {
    _page = 1;
    setState(() {
      _emoticonList.clear();
    });
    await _getEmoticonList(keyword, _page);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _page++;
    await _getEmoticonList(keyword, _page);
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("与“$keyword”相关的表情"),
      ),
      body: SmartRefresher(
        child: ListView.builder(
            itemCount: _emoticonList.length,
            itemBuilder: (context, index) {
              Emoticon emoticon = _emoticonList[index];
              return InkWell(
                child: Image.network(
                  emoticon.url,
                  width: screenWidth,
                ),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondAnimation) {
                    return new ImagePreview(
                      currentIndex: _emoticonList.indexOf(emoticon),
                      imageUrlList: _emoticonList
                          .map(
                              (item) => item.url.replaceAll("bmiddle", "large"))
                          .toList(),
                    );
                  }, transitionsBuilder:
                          (context, animation, secondAnimation, child) {
                    return AnimationUtils.createScaleTransition(
                        animation, child);
                  }));
                },
              );
            }),
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: ClassicFooter(
          loadingText: "正在加载中...",
          idleText: _noData ? "没有更多了..." : "加载更多...",
          idleIcon:
              _noData ? null : Icon(Icons.arrow_upward, color: Colors.grey),
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
