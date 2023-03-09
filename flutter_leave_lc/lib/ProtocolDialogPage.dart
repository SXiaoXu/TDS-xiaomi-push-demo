import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapplc/Privacy.dart';
import 'Common/Global.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';
import 'UserProtocol.dart';

class ProtocolDialog extends StatefulWidget {
  @override
  _ProtocolDialogState createState() => _ProtocolDialogState();
}

class _ProtocolDialogState extends State<ProtocolDialog> {
  TapGestureRecognizer _userProtocolRecognizer;
  TapGestureRecognizer _privacyRecognizer;

//协议说明文案
  String userPrivateProtocol =
      "我们非常重视您的个人信息和隐私保护，我们将按法律法规要求，采取严格的安全保护措施，保护您的个人隐私信息。为了向您提供更好的服务，在使用我们的产品前，请您仔细阅读完整版 ";
  String protocolDetail = '''

1. 为了向您提供账户注册服务，我们会收集您的必要个人信息，包括当前应用使用的用户名与密码用来创建账号，绑定用户手机号码。
2. LeaveTD APP 不会收集设备 Mac 地址，也不会采集唯一设备识别码（如 IMEI / android ID / IDFA / OPENUDID / GUID、SIM 卡 IMSI 信息等）对用户进行唯一标识。
3. LeaveTD APP 不会访问用户其他应用的数据信息，也不会将您的信息共享给第三方。
4. 您可以查询、更正、以及注销账户信息。
    ''';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      // initData();
      showAgreementDialog();
    });
  }

  // 弹出对话框
  Future<bool> showAgreementDialog() async {
    //注册协议的手势
    _userProtocolRecognizer = TapGestureRecognizer();
    //隐私协议的手势
    _privacyRecognizer = TapGestureRecognizer();
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, //页面不可点击
      builder: (context) {
        return new WillPopScope(
            //加一层WillPopScope用于禁止侧滑返回上一页，设置onWillPop=false
            child: AlertDialog(
              title: Text("温馨提示"),
              content: Container(
                height: 240,
                padding: EdgeInsets.all(12),
                //可滑动布局
                child: SingleChildScrollView(
                  child: buildContent(context),
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text("不同意并退出 APP"),
                  onPressed: () {
                    saveAgrement(false);
                    Navigator.of(context).pop(); // 关闭对话框
                    // 关闭 APP
                    SystemNavigator.pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text("同意并继续"),
                  onPressed: () {
                    saveAgrement(true);
                    Navigator.of(context).pop(); // 关闭对话框
                    // 返回登录页面
                    Navigator.pushAndRemoveUntil(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => LoginPage()),
                        (_) => false);
                  },
                ),
              ],
            ),
            onWillPop: () async => false);

        // ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            child: ListView(
      padding: EdgeInsets.symmetric(horizontal: 22.0),
      children: <Widget>[
        SizedBox(
          height: kToolbarHeight,
        ),
        SizedBox(height: 50.0),
      ],
    )));
  }

  buildContent(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: userPrivateProtocol,
          style: TextStyle(color: Colors.grey[600]),
          children: [
            TextSpan(
              text: "《用户协议》",
              style: TextStyle(color: Colors.blue),
              // 点击事件
              recognizer: _userProtocolRecognizer
                ..onTap = () {
                  //打开用户协议
                  showUserProtocolPage();
                },
            ),
            TextSpan(
              text: "与",
              style: TextStyle(color: Colors.grey[600]),
            ),
            TextSpan(
              text: "《隐私政策》",
              style: TextStyle(color: Colors.blue),
              // 点击事件
              recognizer: _privacyRecognizer
                ..onTap = () {
                  //打开隐私协议
                  showPrivacyPage();
                },
            ),
            TextSpan(
              text: "的所有条款，包括：" + protocolDetail,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ]),
    );
  }

  showUserProtocolPage() {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new UserProtocolPage(),
      ),
    );
  }

  showPrivacyPage() {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PrivacyPage(),
      ),
    );
  }

  Future saveAgrement(bool isAgree) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAgree', isAgree);
  }
}
