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

  ImagePreviewState(this.currentIndex, this._imageUrlList);

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: currentIndex);
  }

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
              ))
          .toList(),
      controller: _controller,
    );
  }
}
