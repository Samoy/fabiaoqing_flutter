import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/package.dart';
import '../models/emoticon.dart';
import '../pages/detail.dart';
import '../utils/net_utils.dart';
import '../pages/image_preview.dart';
import '../utils/animation_utils.dart';

class PackagesWidget extends StatefulWidget {
  final String categoryId;

  const PackagesWidget({Key key, this.categoryId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new PackagesState(this.categoryId);
  }
}

class PackagesState extends State<PackagesWidget>
    with AutomaticKeepAliveClientMixin {
  final String categoryId;
  List<Package> _packageList = [];
  RefreshController _refreshController;
  var _page = 1;

  PackagesState(this.categoryId);

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
  }

  Future _getPackageList(categoryId, page) async {
    var res = await NetUtils.get(
        context, "package/list?categoryId=$categoryId&page=$page");
    if (res["data"] != null) {
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
    await _getPackageList(categoryId, _page);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _page++;
    await _getPackageList(categoryId, _page);
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
                    padding: EdgeInsets.all(8),
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                package.name,
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                              ),
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
                              child: Image.network(
                                emoticon.url,
                                width: imgWidth,
                                height: imgWidth,
                                fit: BoxFit.cover,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      footer: ClassicFooter(loadingText: "正在加载中...", idleText: "加载更多..."),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
