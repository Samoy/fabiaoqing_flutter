import 'package:flutter/material.dart';
import 'dart:io';
import '../widgets/packages_widget.dart';

/// 搜索功能以下未实现
/// 1.与应用主题不匹配
/// 2.占位符应该使用中文
/// 3.历史记录
class MySearchDelegate extends SearchDelegate {
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
  Widget buildSuggestions(BuildContext context) {
    return new Container();
  }
}
