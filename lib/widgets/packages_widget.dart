import 'package:flutter/material.dart';
import '../models/package.dart';
import '../models/emoticon.dart';

class PackagesWidget extends StatelessWidget {
  final List<Package> _packageList;

  PackagesWidget(this._packageList);

  _gotoDetail(BuildContext context, package) {

  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return ListView.separated(
        separatorBuilder: (context, index) => new Divider(
              color: Colors.transparent,
              height: 8,
            ),
        itemCount: _packageList.length,
        itemBuilder: (context, index) {
          Package package = _packageList[index];
          return GestureDetector(
            child: Container(
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: new Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              package.name,
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                            ),
                            Text(
                              "${package.count}个表情",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: package.list.map((Emoticon emoticon) {
                          var imgWidth = (screenWidth - 8 * 4) / 3;
                          return Image.network(
                            emoticon.url,
                            width: imgWidth,
                            height: imgWidth,
                            fit: BoxFit.cover,
                          );
                        }).toList(),
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      ),
                    ],
                  )),
              color: Colors.white,
            ),
            onTap: () => _gotoDetail(context, package),
          );
        });
  }
}
