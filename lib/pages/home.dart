import 'package:flutter/material.dart';
import '../utils/net_utils.dart';
import '../models/category.dart';
import '../widgets/packages_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  var _categories = <Category>[];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _categories.length);
    _getCategories();
  }

  void _getCategories() async {
    var res = await NetUtils.get(context, "category/list");
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
