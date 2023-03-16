import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'Login.dart';

class PrivacyPage extends StatefulWidget {
  @override
  _UserProtocolPageState createState() => new _UserProtocolPageState();
}

class _UserProtocolPageState extends State<PrivacyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: "https://xiaomi.goodluckin.top/",
      appBar: AppBar(
        //导航栏
        title: Text("用户隐私政策"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          children: [
            TextButton(
              child: Text("同意协议"),
              onPressed: () {
                // 跳转到登录页面
                Navigator.pushAndRemoveUntil(
                    context,
                    new MaterialPageRoute(builder: (context) => LoginPage()),
                        (_) => false);
              },
            ),
            TextButton(
              child: Text("拒绝协议"),
              onPressed: () {
                // 跳转到登录页面
                Navigator.pushAndRemoveUntil(
                    context,
                    new MaterialPageRoute(builder: (context) => LoginPage()),
                        (_) => false);
              },
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
        ),
      ),
      withZoom: true,
      // 允许网页缩放
      withLocalStorage: true,
      // 允许LocalStorage
      withJavascript: true, // 允许执行js代码
    );
  }
}
