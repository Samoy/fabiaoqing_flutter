import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fabiaoqing/common/common_user.dart';
import 'package:fabiaoqing/models/user.dart';
import 'package:fabiaoqing/utils/alert_utils.dart';
import 'package:fabiaoqing/utils/cache_utils.dart';
import 'package:fabiaoqing/utils/file_utils.dart';
import 'package:fabiaoqing/utils/net_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:image_pickers/CropConfig.dart';
import 'package:image_pickers/Media.dart';
import 'package:image_pickers/UIConfig.dart';
import 'package:toast/toast.dart';

class ProfilePage extends StatefulWidget {
  final User _user;
  final Function onChangeProfile;

  @override
  State<StatefulWidget> createState() {
    return _ProfileState(_user, onChangeProfile: this.onChangeProfile);
  }

  ProfilePage(this._user, {this.onChangeProfile(User user)});
}

class _ProfileState extends State<ProfilePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  User _user;

  User _newUser;

  bool _isEdit = false;

  final Function onChangeProfile;

  _ProfileState(this._user, {this.onChangeProfile(User user)});

  /// 初始化时对User进行深复制,避免_newUser改变后_user也发生改变，
  /// 但这样会有一个问题,比较的时候使用"=="和"identical()"都会返回false
  /// 因此需要对每个属性都进行比对，参见[isSameUser]
  /// 暂无更好的解决办法
  @override
  void initState() {
    super.initState();
    if (_user != null) {
      _newUser = User.fromJson(_user.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileList = [
      {"title": "头像", "value": _newUser.avatar},
      {"title": "昵称", "value": _newUser.nickname},
      {"title": "性别", "value": _newUser.sex ? "男" : "女"},
      {"title": "介绍", "value": _newUser.description}
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("个人资料"),
        elevation: 0,
        actions: <Widget>[
          FlatButton(
            child: Text("保存"),
            textColor: Colors.white,
            disabledTextColor: Colors.white70,
            onPressed: _isEdit ? _save : null,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    var item = profileList[index];
                    Widget valueWidget = Text(item["value"]);
                    if (index == 0) {
                      valueWidget = ClipOval(
                        child: item["value"].isEmpty
                            ? Image.asset(
                                "images/logo.jpg",
                                width: 28,
                                height: 28,
                              )
                            : isNetworkPath(item["value"])
                                ? CacheUtils.cacheNetworkImage(
                                    context, item["value"],
                                    width: 28, height: 28)
                                : Image(
                                    image: FileImage(File(item["value"])),
                                    width: 28,
                                    height: 28,
                                  ),
                      );
                    }
                    return InkWell(
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(top: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(item["title"]),
                            Row(
                              children: <Widget>[
                                valueWidget,
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      onTap: () => _tapRow(index),
                    );
                  },
                  itemCount: profileList.length),
            ),
          )
        ],
      ),
    );
  }

  _tapRow(int index) {
    switch (index) {
      case 0:
        selectImages();
        break;
      case 1:
        AlertUtils.showPrompt(context, "请输入昵称", onOK: (text) {
          setState(() {
            _isEdit = true;
            _newUser.nickname = text;
          });
        });
        break;
      case 2:
        AlertUtils.showSelectDialog(context, "请选择性别", ["男", "女"],
            onSelect: (index) {
          setState(() {
            _newUser.sex = index == 0;
            if (!isSameUser(_newUser, _user)) {
              setState(() {
                _isEdit = true;
              });
            }
          });
        });
        break;
      case 3:
        AlertUtils.showPrompt(context, "请用一句话介绍你自己", onOK: (text) {
          setState(() {
            _isEdit = true;
            _newUser.description = text;
          });
        });
        break;
      default:
        break;
    }
  }

  bool isSameUser(User source, User target) {
    return source.avatar == target.avatar &&
        source.nickname == target.nickname &&
        source.sex == target.sex &&
        source.description == target.description &&
        source.telephone == target.telephone &&
        source.objectId == target.objectId &&
        source.email == target.email;
  }

  Future<void> selectImages() async {
    List<Media> _listImagePaths = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        selectCount: 1,
        showCamera: true,
        compressSize: 500,
        uiConfig: UIConfig(uiThemeColor: Colors.red),
        cropConfig: CropConfig(enableCrop: true, width: 2, height: 1));
    setState(() {
      _isEdit = true;
      _newUser.avatar = _listImagePaths[0].path;
    });
  }

  void _save() async {
    FormData formData = FormData.from({
      "userId": CommonUser.getInstance().getUserId(),
      "sex": _newUser.sex ? 1 : 0,
      "nickname": _newUser.nickname,
      "description": _newUser.description
    });
    if (_newUser.avatar.isNotEmpty && !isNetworkPath(_newUser.avatar)) {
      File file = File(_newUser.avatar);
      String suffix = file.path.split(".").last;
      formData.add(
          "avatar", UploadFileInfo(file, "${_user.objectId}_avatar.$suffix"));
    }

    AlertUtils.showLoading(context);
    var res = await NetUtils.getInstance(context).filePost(
        "user/update_profile", formData,
        headers: {"token": CommonUser.getInstance().getToken()});
    Navigator.pop(context);
    if (res != null && res["data"] != null) {
      print(res);
      Toast.show("ヾ(^▽^ヾ)，保存成功啦", context, gravity: Toast.CENTER);
      setState(() {
        _newUser = User.fromJson(res["data"]);
        _user = User.fromJson(res["data"]);
        _isEdit = false;
      });
      this.onChangeProfile(_newUser);
    }
  }
}
