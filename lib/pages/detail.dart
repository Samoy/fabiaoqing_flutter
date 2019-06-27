import 'package:flutter/material.dart';
import '../models/emoticon.dart';
import '../utils/net_utils.dart';

class DetailPage extends StatefulWidget {
  final String packageId;

  @override
  State<StatefulWidget> createState() {
    return new DetailState(packageId);
  }

  DetailPage(this.packageId);
}

class DetailState extends State<DetailPage> {
  final String packageId;
  var _emoticonList = <Emoticon>[];

  DetailState(this.packageId);

  @override
  void initState() {
    super.initState();
    _getEmoticonList();
  }

  void _getEmoticonList() async {
    var res = await NetUtils.get(context, "package/list/detail?id=$packageId");
    if (res["data"] != null) {
      for (var item in res["data"]) {
        setState(() {
          _emoticonList.add(Emoticon.fromJson(item));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("表情包详情"),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: _emoticonList
                  .map((f) => Image.network(
                        f.url,
                        fit: BoxFit.none,
                        scale: 2.0,
                      ))
                  .toList(),
            )),
      ),
    );
  }
}
