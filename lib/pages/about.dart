import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("关于"),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Center(
                    child: ClipOval(
                      child: Image.asset(
                        "images/logo.jpg",
                        height: 64,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 16),
                      child: Text(
                        "来发表情吧",
                        style: TextStyle(fontSize: 28, fontFamily: "KuaiLe"),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    child: Text(
                        r'       这是一款斗图神器，无数的表情包供你选择，没有你搜不到，只有你想不到，妈妈再也不用担心我斗图会输了。'),
                  )
                ],
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(TextSpan(
                      text: '官方网站: ',
                      children: <TextSpan>[
                        TextSpan(
                            text: 'https://biaoqing.samoy.fun',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _launchURL(
                                  context, "https://biaoqing.samoy.fun"),
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue)),
                      ],
                    )),
                    Text.rich(TextSpan(
                      text: '电子邮箱: ',
                      children: <TextSpan>[
                        TextSpan(
                            text: 'samoy_young@163.com',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _launchURL(
                                  context, "mailto:samoy_young@163.com"),
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue)),
                      ],
                    ))
                  ],
                ),
              ),
            ),
            Center(
              child: Text(
                "图片素材来源于网络。若有侵权，深表歉意，请联系删除。",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  _launchURL(BuildContext context, url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Toast.show("没有应用程序打开此链接", context);
    }
  }
}
