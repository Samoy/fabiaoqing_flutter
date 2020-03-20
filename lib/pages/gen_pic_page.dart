import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/painting.dart' as painting;

import 'package:flutter/material.dart';

class GenPicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GenPicState();
  }
}

enum Gender { Male, Female }

class _GenPicState extends State {
  Gender _gender = Gender.Male;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '写日记',
          style: TextStyle(fontFamily: 'KuaiLe'),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 160.0, height: 80.0),
                    child: RadioListTile(
                      title: const Text('汉子版'),
                      value: Gender.Male,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                  ),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 160.0, height: 80.0),
                    child: RadioListTile(
                      title: const Text('女汉子版'),
                      value: Gender.Female,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                  )
                ],
              ),
              Image.asset(
                _gender == Gender.Male
                    ? 'images/jichou.jpg'
                    : 'images/jichou_girl.jpg',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              Container(
                width: 300,
                child: TextField(
                  textInputAction: TextInputAction.done,
                  style: TextStyle(color: Colors.black, fontSize: 24),
                  maxLines: null,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: '点击此处输入文字',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 32)),
                ),
              ),
              RaisedButton(
                child: Text('生成'),
                color: Colors.red,
                textColor: Colors.white,
                elevation: 0,
                highlightElevation: 0,
                onPressed: _genPic,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _genPic() {

  }
}
