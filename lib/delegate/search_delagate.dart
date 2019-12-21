import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import '../widgets/packages_widget.dart';

//TODO:搜索未实现历史记录功能
class MySearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => "请输入搜索内容";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = "";
          }
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return new PackagesWidget(keyword: query);
  }

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
    if (query.isEmpty) {
      Toast.show("请先输入搜索内容哦，^_^", context, gravity: Toast.CENTER);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return new Container();
  }
}
