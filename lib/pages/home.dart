import 'package:flutter/material.dart';
import '../utils/net_utils.dart';
import '../models/category.dart';
import '../models/package.dart';
import '../widgets/packages_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  var _categories = <Category>[];
  var _packages = <Package>[];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 0);
    _getCategories();
  }

  @override
  bool get wantKeepAlive => true;

  void _getCategories() async {
    var res = await NetUtils.get(context, "category/list");
    if (res["data"] != null) {
      for (var value in res["data"]) {
        Category category = Category.fromJson(value);
        _categories.add(category);
      }
      setState(() {
        _tabController = TabController(vsync: this, length: _categories.length);
        _tabController.addListener(_changeTab);
      });
      _getPackageList(_categories.first.objectId);
    }
  }

  _changeTab() {
    if (_tabController.index.toDouble() == _tabController.animation.value) {
      _packages.clear();
      _getPackageList(_categories[_tabController.index].objectId);
    }
  }

  void _getPackageList(categoryId) async {
    var res =
        await NetUtils.get(context, "package/list?categoryId=$categoryId");
    if (res["data"] != null) {
      for (var value in res["data"]) {
        Package package = Package.fromJson(value);
        setState(() {
          _packages.add(package);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      appBar: AppBar(
        title: Text("来发表情吧"),
        bottom: TabBar(
            tabs: _categories.map((Category category) {
              return Tab(text: category.name);
            }).toList(),
            controller: _tabController,
            isScrollable: true),
      ),
      body: TabBarView(
        children: _categories.map((Category category) {
          return new PackagesWidget(_packages);
        }).toList(),
        controller: _tabController,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}
