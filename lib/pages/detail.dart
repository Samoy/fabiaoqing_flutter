import 'package:flutter/material.dart';
import '../models/emoticon.dart';
import '../utils/net_utils.dart';

class DetailPage extends StatefulWidget {
  final String packageId;
  final String packageName;

  @override
  State<StatefulWidget> createState() {
    return new DetailState(packageId, packageName);
  }

  DetailPage(this.packageId, this.packageName);
}

class DetailState extends State<DetailPage> {
  final String packageId;
  final String packageName;
  var _emoticonList = <Emoticon>[];

  DetailState(this.packageId, this.packageName);

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
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8, top: 8, right: 8),
                    child: Text(
                      packageName,
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ] +
                    _emoticonList
                        .map((f) => Padding(
                      child: Image.network(f.url, fit: BoxFit.cover),
                      padding: EdgeInsets.all(8),
                    ))
                        .toList(),
              ),
            )),
      ),
    );
  }
}
