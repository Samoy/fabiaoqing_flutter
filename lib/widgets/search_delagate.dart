import 'package:flutter/material.dart';
import 'dart:io';

class MySearchDelegate extends SearchDelegate {
  String _keyword;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return new Center(
      child: Text("哈哈哈"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return new Center(child: Text(""));
  }
}
