import 'package:flutter/material.dart';
import '../utils/net_utils.dart';
import '../model/category.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  var _categories = <Category>[];

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  void _getCategories() async {
    var res = await NetUtils.get(context, "category/list");
    if (res["data"] != null) {
      for (var value in res["data"]) {
        Category category = Category.fromJson(value);
        setState(() {
          _categories.add(category);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_categories.length);
    return new DefaultTabController(
        length: _categories.length,
        child: new Scaffold(
          appBar: new AppBar(
              title: Text("来发表情吧"),
              bottom: new TabBar(
                tabs: _categories.map((Category category) {
                  return new Tab(
                    text: category.name,
                  );
                }).toList(),
                isScrollable: true,
              )),
          body: new TabBarView(
              children: _categories.map((Category category) {
            return new Padding(
              padding: EdgeInsets.all(16),
              child: Text(category.name),
            );
          }).toList()),
        ));
  }
}
