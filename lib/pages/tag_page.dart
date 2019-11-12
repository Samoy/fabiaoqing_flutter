import 'dart:math';

import 'package:fabiaoqing/pages/emoticon_list.dart';
import 'package:flutter/material.dart';
import '../utils/net_utils.dart';
import '../models/tag.dart';

class TagPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TagState();
  }
}

class TagState extends State<TagPage> {
  List<Tag> _tagList = [];
  List<Color> _colors = [
    Colors.amber,
    Colors.orange,
    Colors.green,
    Colors.lime
  ];

  Future _getTags() async {
    var res = await NetUtils.getInstance(context).get("tag/rand_list");
    if (res["data"] != null) {
      _tagList.clear();
      for (var value in res["data"]) {
        Tag tag = Tag.fromJson(value);
        setState(() {
          _tagList.add(tag);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("标签墙"),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Center(
                heightFactor: 1,
                widthFactor: 1,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: _tagList.map((tag) {
                    int num = Random().nextInt(4);
                    return InkWell(
                      child: Chip(
                        backgroundColor: _colors[num],
                        labelPadding: EdgeInsets.only(left: 20, right: 20),
                        label: Text(
                          tag.name,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new EmoticonList(
                              keyword: tag.name,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              Center(
                child: FlatButton(
                  child: Text(
                    _tagList.isEmpty ? "" : "换一批",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    _getTags();
                  },
                ),
              )
            ],
          ),
        ));
  }
}
