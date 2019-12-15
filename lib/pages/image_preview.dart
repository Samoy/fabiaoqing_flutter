import 'dart:typed_data';
import 'dart:ui';
import 'package:fabiaoqing/common/api_result_code.dart';
import 'package:fabiaoqing/common/common_user.dart';
import 'package:fabiaoqing/models/emoticon.dart';
import 'package:fabiaoqing/utils/net_utils.dart';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_save/image_save.dart';

class ImagePreview extends StatefulWidget {
  final int currentIndex;
  final List<Emoticon> imageList;

  const ImagePreview({Key key, this.currentIndex, this.imageList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ImagePreviewState(currentIndex, imageList);
  }
}

class ImagePreviewState extends State<ImagePreview> {
  final currentIndex;
  final List<Emoticon> _imageList;
  int _imageHeight = 0;
  PageController _controller;
  final List<String> _shareChannels = [
    "保存到手机",
    "发送给QQ好友",
    "发送给微信好友",
    "收藏",
    "取消"
  ];

  ImagePreviewState(this.currentIndex, this._imageList);

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: currentIndex);
  }

  _onTapShare(int index, Emoticon emoticon) {
    Navigator.pop(context);
    switch (index) {
      //保存到手机
      case 0:
        _saveImageToAlbum(emoticon.url);
        break;
      //分享到QQ
      case 1:
        _shareToQQ(emoticon.url);
        break;
      //分享到微信
      case 2:
        _shareToWX(emoticon.url);
        break;
      //收藏
      case 3:
        _collect(emoticon.objectId);
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
    String suffix = (url as String).split(".").last;
    String path =
        await ImageSave.saveImage(suffix, Uint8List.fromList(res.data));
    print("保存路径:$path");
    Toast.show(
        Platform.isAndroid && path == null ? "(╥╯^╰╥)，保存失败了" : "ヾ(^▽^ヾ)，保存成功啦",
        context,
        gravity: Toast.CENTER);
  }

  _shareToQQ(url) {}

  _shareToWX(url) {}

  _collect(emoticonId) async {
    var res = await NetUtils.getInstance(context).post("favorite/add", {
      "userId": CommonUser.getInstance().getUserId(),
      "emoticonId": emoticonId
    }, headers: {
      "token": CommonUser.getInstance().getToken()
    });
    if (res != null && res["code"] == REQUEST_SUCCESS) {
      Toast.show("ヾ(^▽^ヾ)，收藏成功啦", context, gravity: Toast.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = window.physicalSize.height;
    return new PageView(
      children: _imageList.map((image) {
        var imageWidget = Image.network(
          image.url.replaceAll("bmiddle", "large"),
          fit: BoxFit.fitWidth,
        );
        imageWidget.image
            .resolve(ImageConfiguration())
            .addListener(new ImageStreamListener((image, _) {
          if (mounted) {
            setState(() {
              _imageHeight = image.image.height;
            });
          }
        }));
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
                                onTap: () => _onTapShare(index, image),
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
