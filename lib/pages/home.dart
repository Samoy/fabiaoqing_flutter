import 'package:flutter/material.dart';
import '../utils/net_utils.dart';
import '../models/category.dart';
import 'package:fabiaoqing/delegate/search_delagate.dart';
import '../widgets/packages_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> with TickerProviderStateMixin {
  var _categories = <Category>[];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _categories.length);
    _getCategories();
  }

  void _getCategories() async {
    var res = await NetUtils.getInstance(context).get("category/list");
    if (res["data"] != null) {
      for (var value in res["data"]) {
        Category category = Category.fromJson(value);
        _categories.add(category);
      }
      setState(() {
        _tabController = TabController(vsync: this, length: _categories.length);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO:实现APPBar吸顶效果
    return new Scaffold(
      appBar: AppBar(
        title: Text("来发表情吧"),
        elevation: 0,
        bottom: TabBar(
          tabs: _categories.map((Category category) {
            return Tab(text: category.name);
          }).toList(),
          controller: _tabController,
          isScrollable: true,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () => showSearch(
              context: context,
              delegate: MySearchDelegate(),
            ),
          )
        ],
      ),
      body: TabBarView(
        children: _categories.map((Category category) {
          return new PackagesWidget(
            categoryId: category.objectId,
          );
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
