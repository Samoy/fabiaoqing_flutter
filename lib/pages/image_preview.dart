import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  final currentIndex;
  final imageUrlList;

  const ImagePreview({Key key, this.currentIndex, this.imageUrlList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ImagePreviewState(currentIndex, imageUrlList);
  }
}

class ImagePreviewState extends State<ImagePreview> {
  final currentIndex;
  final _imageUrlList;
  PageController _controller;
  final List<String> _shareChannels = [
    "保存到手机",
    "发送给QQ好友",
    "发送给微信好友",
    "收藏",
    "取消"
  ];

  ImagePreviewState(this.currentIndex, this._imageUrlList);

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: currentIndex);
  }

  _onTapShare(int index) {}

  @override
  Widget build(BuildContext context) {
    var imageUrlList = _imageUrlList as List<String>;
    return new PageView(
      children: imageUrlList
          .map((url) => GestureDetector(
                child: Image.network(
                  url,
                  fit: BoxFit.fitWidth,
                ),
                onTap: () => Navigator.of(context).pop(),
                onLongPress: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                            height: 295,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                double dividerHeight = 0.5;
                                if (index == _shareChannels.length - 1) {
                                  dividerHeight = 0;
                                }
                                if (index == _shareChannels.length - 2) {
                                  dividerHeight = 12;
                                }
                                return Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        _shareChannels[index],
                                        textAlign: TextAlign.center,
                                      ),
                                      onTap: () => _onTapShare(index),
                                    ),
                                    Container(
                                      height: dividerHeight,
                                      color: Colors.grey[300],
                                    )
                                  ],
                                );
                              },
                              // separatorBuilder: (context, index) => Divider(),
                              itemCount: _shareChannels.length,
                            ));
                      });
                },
              ))
          .toList(),
      controller: _controller,
    );
  }
}
