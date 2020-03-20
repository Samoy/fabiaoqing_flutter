import 'package:fabiaoqing/pages/gen_pic_page.dart';
import 'package:flutter/material.dart';

class DiyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DiyState();
  }
}

class _DiyState extends State<DiyPage> {
  final _images = [
    'images/xieriji.jpg',
    'images/wangjingze.jpg',
    'images/zhangxueyou.jpg',
    'images/qiegewala.jpg',
    'images/weisuoyuwei.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("DIY", style: TextStyle(fontFamily: "KuaiLe")),
        elevation: 0,
      ),
      body: Container(
          child: ListView.separated(
              itemBuilder: (context, index) => InkWell(
                    child: Image.asset(
                      _images[index],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => GenPicPage())),
                  ),
              separatorBuilder: (context, index) => Divider(
                    color: Colors.grey[200],
                  ),
              itemCount: _images.length)),
    );
  }
}
