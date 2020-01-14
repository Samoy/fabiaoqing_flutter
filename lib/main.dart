import 'package:fabiaoqing/common/common_user.dart';
import 'package:fabiaoqing/common/constant.dart';
import 'package:fabiaoqing/pages/diy_page.dart';
import 'package:fabiaoqing/pages/mine.dart';
import 'package:flutter/material.dart';
import 'package:fabiaoqing/pages/home.dart';
import 'package:fabiaoqing/pages/tag_page.dart';
import 'package:flutter/services.dart';
import 'package:sharesdk_plugin/sharesdk_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final SystemUiOverlayStyle _style =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);

  @override
  Widget build(BuildContext context) {
    CommonUser.init();
    SystemChrome.setSystemUIOverlayStyle(_style);
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red, accentColor: Colors.blue),
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    TagPage(),
    //DiyPage(),
    MinePage(),
  ];

  @override
  void initState() {
    super.initState();
    ShareSDKRegister register = ShareSDKRegister();
    register.setupQQ(QQ_APP_ID, QQ_APP_KEY);
    SharesdkPlugin.regist(register);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: _widgetOptions,
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 4,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_emoticon),
            title: Text(
              '表情包',
              style: TextStyle(fontFamily: "KuaiLe"),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/tag.png',
              width: 20,
              height: 20,
              color: _selectedIndex == 1 ? Colors.blue : Colors.grey[700],
            ),
            title: Text('标签墙', style: TextStyle(fontFamily: "KuaiLe")),
          ),
//          BottomNavigationBarItem(
//            icon: Image.asset(
//              'images/tab_diy.png',
//              width: 20,
//              height: 20,
//              color: _selectedIndex == 2 ? Colors.blue : Colors.grey[700],
//            ),
//            title: Text('DIY', style: TextStyle(fontFamily: "KuaiLe")),
//          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('我的', style: TextStyle(fontFamily: "KuaiLe")))
        ],
        currentIndex: _selectedIndex,
        selectedIconTheme: IconThemeData(color: Colors.blue),
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
