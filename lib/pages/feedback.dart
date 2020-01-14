import 'package:fabiaoqing/utils/alert_utils.dart';
import 'package:fabiaoqing/utils/net_utils.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

//fixme:虽然可以调节是否匿名，但目前实际均为匿名提交
class FeedbackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedbackState();
  }
}

class _FeedbackState extends State<FeedbackPage> {
  bool anonymous = true;
  String _feedback = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("用户反馈"),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              maxLines: 10,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "请输入反馈内容(不多于1000字)",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13.0),
                  contentPadding: EdgeInsets.all(12),
                  enabledBorder: null,
                  disabledBorder: null),
              onChanged: (text) {
                setState(() {
                  _feedback = text;
                });
              },
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                child: InkWell(
                  child: Container(
                    width: 60,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          anonymous
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          size: 20,
                          color: anonymous ? Colors.red : Colors.grey,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: Text("匿名"),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      anonymous = !anonymous;
                    });
                  },
                )),
            Container(
              width: double.infinity,
              child: RaisedButton(
                child: Text("提交"),
                color: Colors.red,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                elevation: 0,
                highlightElevation: 0,
                onPressed: _submitFeedback,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _submitFeedback() async {
    if (_feedback.isEmpty) {
      Toast.show("请先填写内容哦", context, gravity: Toast.CENTER);
      return;
    }
    AlertUtils.showLoading(context);
    await NetUtils.getInstance(context)
        .post("feedback/submit", {"content": _feedback});
    Navigator.pop(context);
    AlertUtils.showAlert(context, "反馈成功",
        message: "ヾ(^▽^ヾ)，非常感谢您对我们的反馈",
        onOK: () => Navigator.pop(context),
        canCancel: false);
  }
}
