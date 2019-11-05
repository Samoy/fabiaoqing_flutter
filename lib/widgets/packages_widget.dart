import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/package.dart';
import '../models/emoticon.dart';
import '../pages/package_detail.dart';
import '../utils/net_utils.dart';
import '../pages/image_preview.dart';
import '../utils/animation_utils.dart';

class PackagesWidget extends StatefulWidget {
  final String categoryId;
  final String keyword;

  const PackagesWidget({Key key, this.categoryId, this.keyword})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new PackagesState(categoryId, keyword);
  }
}

class PackagesState extends State<PackagesWidget>
    with AutomaticKeepAliveClientMixin {
  final String categoryId;
  final String keyword;
  List<Package> _packageList = [];
  RefreshController _refreshController;
  var _page = 1;
  bool _noData = false;

  PackagesState(this.categoryId, this.keyword);

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
  }

  Future _getPackageList(String categoryId, String keyword, int page) async {
    setState(() {
      _noData = false;
    });
    var res;
    if (categoryId != null && categoryId.isNotEmpty) {
      res = await NetUtils.getInstance(context)
          .get("package/list?categoryId=$categoryId&page=$page");
    } else if (keyword != null && keyword.isNotEmpty) {
      res = await NetUtils.getInstance(context)
          .get("package/list/search?keyword=$keyword&page=$page");
    }
    if (res["data"] != null) {
      if (res["data"].isEmpty) {
        setState(() {
          _noData = true;
        });
        return;
      }
      for (var value in res["data"]) {
        Package package = Package.fromJson(value);
        setState(() {
          _packageList.add(package);
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
      _packageList.clear();
    });
    await _getPackageList(categoryId, keyword, _page);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _page++;
    await _getPackageList(categoryId, keyword, _page);
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var screenWidth = MediaQuery.of(context).size.width;
    return SmartRefresher(
      child: ListView.separated(
          separatorBuilder: (context, index) => new Divider(
                color: Colors.transparent,
                height: 8,
              ),
          itemCount: _packageList.length,
          itemBuilder: (context, index) {
            Package package = _packageList[index];
            return GestureDetector(
              child: Container(
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                  child: Text(
                                package.name,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                              )),
                              Text(
                                "${package.count}个表情",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: package.list.map((Emoticon emoticon) {
                            var imgWidth = (screenWidth - 8 * 4) / 3;
                            return GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(left: 4, right: 4),
                                child: Image.network(
                                  emoticon.url,
                                  width: imgWidth,
                                  height: imgWidth,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              onLongPress: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondAnimation) {
                                  return new ImagePreview(
                                    currentIndex:
                                        package.list.indexOf(emoticon),
                                    imageUrlList: package.list
                                        .map((f) => f.url
                                            .replaceAll("bmiddle", "large"))
                                        .toList(),
                                  );
                                }, transitionsBuilder: (context, animation,
                                        secondAnimation, child) {
                                  return AnimationUtils.createScaleTransition(
                                      animation, child);
                                }));
                              },
                            );
                          }).toList(),
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                      ],
                    )),
                color: Colors.white,
              ),
              onTap: () => _gotoDetail(context, package),
            );
          }),
      enablePullDown: true,
      enablePullUp: true,
      header: MaterialClassicHeader(),
      footer: ClassicFooter(
        loadingText: "正在加载中...",
        idleText: _noData ? "没有更多了..." : "加载更多...",
        idleIcon: _noData ? null : Icon(Icons.arrow_upward, color: Colors.grey),
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
