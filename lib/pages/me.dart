import 'package:flutter/material.dart';

class MePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MeState();
  }
}

class _MeState extends State {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("我的"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ClipOval(
                          child: Image.network(
                            "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1624240531,2195794812&fm=26&gp=0.jpg",
                            width: 80,
                            height: 80,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 12),
                          child: Column(children: <Widget>[
                            Text(
                              "猪猪侠",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "查看并编辑个人资料",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ], crossAxisAlignment: CrossAxisAlignment.start),
                        )
                      ],
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 32,
                      color: Colors.grey[400],
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                onTap: _onTapAvatar,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1624240531,2195794812&fm=26&gp=0.jpg",
                        width: 60,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        child: Text(
                          "表情图库",
                          textAlign: TextAlign.center,
                        ),
                        margin: EdgeInsets.only(top: 8),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  onTap: _onTapMyFavorite,
                ),
                InkWell(
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1624240531,2195794812&fm=26&gp=0.jpg",
                        width: 60,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        child: Text(
                          "我的收藏",
                          textAlign: TextAlign.center,
                        ),
                        margin: EdgeInsets.only(top: 8),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  onTap: _onTapMyFavorite,
                ),
                InkWell(
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1624240531,2195794812&fm=26&gp=0.jpg",
                        width: 60,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        child: Text(
                          "历史记录",
                          textAlign: TextAlign.center,
                        ),
                        margin: EdgeInsets.only(top: 8),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  onTap: _onTapMyFavorite,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            color: Colors.white,
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            color: Colors.white,
          )
        ],
      ),
    );
  }

  _onTapAvatar() {
    print("点击了");
  }

  void _onTapMyFavorite() {
    print("点击我的收藏");
  }
}
