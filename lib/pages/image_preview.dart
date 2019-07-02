import 'dart:typed_data';
import 'dart:ui';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_saver/image_picker_saver.dart';

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
  int _imageHeight = 0;
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

  _onTapShare(int index, String url) {
    Navigator.pop(context);
    switch (index) {
      //保存到手机
      case 0:
        _saveImageToAlbum(url);
        break;
      //分享到QQ
      case 1:
        _shareToQQ(url);
        break;
      //分享到微信
      case 2:
        _shareToWX(url);
        break;
      //收藏
      case 3:
        _collect(url);
        break;
    }
  }

  _saveImageToAlbum(url) async {
    if (Platform.isAndroid) {
      PermissionStatus status = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (status != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("提示"),
                  content:
                      Text("由于您拒绝了应用程序访问你的手机储存,因此无法保存图片到相册,您可以稍后在系统设置中打开此权限。"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        PermissionHandler().openAppSettings();
                      },
                      child: Text("打开系统设置"),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("确定"),
                    ),
                  ],
                );
              });
        }
      }
    }
    Response<List<int>> res = await Dio().get<List<int>>(url,
        options: Options(responseType: ResponseType.bytes));
    String path =
        await ImagePickerSaver.saveFile(fileData: Uint8List.fromList(res.data));
    Toast.show(path != null ? "成功保存图片到相册" : "保存失败", context);
  }

  _shareToQQ(url) {}

  _shareToWX(url) {}

  _collect(url) {}

  @override
  Widget build(BuildContext context) {
    var imageUrlList = _imageUrlList as List<String>;
    var screenHeight = window.physicalSize.height;
    return new PageView(
      children: imageUrlList.map((url) {
        var imageWidget = Image.network(
          url,
          fit: BoxFit.fitWidth,
        );
        imageWidget.image.resolve(ImageConfiguration()).addListener((image, _) {
          if (mounted) {
            setState(() {
              _imageHeight = image.image.height;
            });
          }
        });
        var content = GestureDetector(
          child: imageWidget,
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
                                onTap: () => _onTapShare(index, url),
                              ),
                              Container(
                                height: dividerHeight,
                                color: Colors.grey[300],
                              )
                            ],
                          );
                        },
                        itemCount: _shareChannels.length,
                      ));
                });
          },
        );
        return _imageHeight > screenHeight
            ? SingleChildScrollView(
                child: Center(
                child: content,
              ))
            : content;
      }).toList(),
      controller: _controller,
    );
  }
}
