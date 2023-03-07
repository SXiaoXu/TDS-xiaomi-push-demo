import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'Login.dart';
import 'HomeBottomBar.dart';
import 'Common/Global.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _userName, _password;
  bool _isObscure = true;
  Color _eyeColor;
  String _userIfLeancloud = 'LeanCloud 华北员工';
  static const platformNorthChina = MethodChannel('initLC-NorthChina');
  static const platformEastChina = MethodChannel('initLC-EastChina');
  static const platformUS = MethodChannel('initLC-US');
  static const platformTDS = MethodChannel('initTDS');
  static const platformTest = MethodChannel('init-Test');

  Future userSignUp(String name, String password) async {
    CommonUtil.showLoadingDialog(context); //发起请求前弹出loading

    initLeanCloud().then((response) {
      saveUserType(this._userIfLeancloud);
      saveUserProfile(name, password);
      signUp(name, password).then((value) {
        login(name, password).then((value) {
          Navigator.pop(context); //销毁 loading
          Navigator.pushAndRemoveUntil(
              context,
              new MaterialPageRoute(builder: (context) => HomeBottomBarPage()),
              (_) => false);
        }).catchError((error) {
          showToastRed(error.message);
          Navigator.pop(context); //销毁 loading
        });
      }).catchError((error) {
        showToastRed(error.message);
        Navigator.pop(context); //销毁 loading
      });
    }).catchError((error) {
      showToastRed(error.message);
      Navigator.pop(context); //销毁 loading
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                SizedBox(height: 20.0),
                buildChooseUserDropdownButton(context),
                SizedBox(height: 30.0),
                buildEmailTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
                buildRegisterText(context),
              ],
            )));
  }

  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('已经有账号？'),
            GestureDetector(
              child: Text(
                '点击登录',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                // 跳转到登录页面
                Navigator.pushAndRemoveUntil(
                    context,
                    new MaterialPageRoute(builder: (context) => LoginPage()),
                    (_) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '注册',
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
          color: Colors.black,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              //注册
              userSignUp(this._userName, this._password);
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: 'Password',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  Padding buildChooseUserDropdownButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DropdownButton<String>(
            value: this._userIfLeancloud,
            onChanged: (String newValue) {
              setState(() {
                this._userIfLeancloud = newValue;
              });
            },
            items: <String>['LeanCloud 华北员工','LeanCloud 华东员工','LeanCloud 国际员工','TDS 员工','其他区员工']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'User Name',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入用户名';
        }
        return null;
      },
      onSaved: (String value) => _userName = value,
    );
  }

  Padding buildTitle() {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'LeanCloud 注册',
            style: TextStyle(fontSize: 28.0),
          ),
        ));
  }

  Future login(String name, String password) async {
    LCUser user = await LCUser.login(name, password);
  }

  Future signUp(String name, String password) async {
    LCUser user = LCUser();
    user.username = name;
    user.password = password;
    await user.signUp();
  }

  Future initLeanCloud() async {

    if (_userIfLeancloud == 'LeanCloud 华北员工') {
      LeanCloud.initialize(
          'eLAwFuK8k3eIYxh29VlbHu2N-gzGzoHsz', 'G59fl4C1uLIQVR4BIiMjxnM3',
          server: 'https://elawfuk8.lc-cn-n1-shared.com',
          queryCache: new LCQueryCache());
    } else if(_userIfLeancloud == 'LeanCloud 华东员工'){
      LeanCloud.initialize('2ke9qjLSGeamYyU7dT6eqvng-9Nh9j0Va', 'FEttS9MjIXgmyvbslSp90aUI',
          server: 'https://2ke9qjls.lc-cn-e1-shared.com',
          queryCache: new LCQueryCache());
    } else if (_userIfLeancloud == 'LeanCloud 国际员工') {
      LeanCloud.initialize(
          'glvame9g0qlj3a4o29j5xdzzrypxvvb30jt4vnvm66klph4r', 'n79rw9ja3eo8n8au838t7pqur5mw88pnnep6ahlr99iq661a',
          server: 'https://usfcm.goodluckin.top',
          queryCache: new LCQueryCache());
    } else if(_userIfLeancloud == 'TDS 员工'){
      LeanCloud.initialize('HoiGvMeacbPWnv12MK', 'FesqQUmlhjMWt6uNrKaV6QPtYgBYZMP9QFmTUk54',
          server: 'https://hoigvmea.cloud.tds1.tapapis.cn',
          queryCache: new LCQueryCache());
    }else{
      //其他区员工，测试区账号
      LeanCloud.initialize('6HKynQEeIYeWpHmF9e7ocY5R-TeStHjQi', 'FLx5kVKBU04k6SxmuIVndMNy',
          server: 'https://api.uc-test1.leancloud.cn',
          queryCache: new LCQueryCache());
    }
    initAndroidSDK(_userIfLeancloud);
  }
  Future initAndroidSDK(String usertype) async {

    if (usertype == 'LeanCloud 华北员工') {
      try {
        await platformNorthChina.invokeMethod('initLC-NorthChina');
        showToastRed("initAndroidSDK-----initLC-NorthChina");
      } on PlatformException catch (e) {
        showToastRed("Android 原生 SDK 初始化失败");
      }
    } else if (usertype == 'LeanCloud 华东员工') {
      try {
        await platformEastChina.invokeMethod('initLC-EastChina');
      } on PlatformException catch (e) {
        showToastRed("Android 原生 SDK 初始化失败");
      }
    } else if(usertype == 'LeanCloud 国际员工'){
      try {
        await platformUS.invokeMethod('initLC-US');
      } on PlatformException catch (e) {
        showToastRed("Android 原生 SDK 初始化失败");
      }
    } else if (usertype == 'TDS 员工') {
      try {
        await platformTDS.invokeMethod('initTDS');
      } on PlatformException catch (e) {
        showToastRed("Android 原生 SDK 初始化失败");
      }
    } else {
      try {
        await platformTest.invokeMethod('init-Test');
      } on PlatformException catch (e) {
        showToastRed("Android 原生 SDK 初始化失败");
      }
    }
  }

  Future saveUserProfile(String username,String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }
}
