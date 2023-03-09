import 'package:flutter/material.dart';
import 'package:flutterapplc/Privacy.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'HomeBottomBar.dart';
import 'ProtocolDialogPage.dart';
import 'SignUp.dart';
import 'Common/Global.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'UserProtocol.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerName = new TextEditingController();
  final TextEditingController _controllerPassword = new TextEditingController();
  static const platformNorthChina = MethodChannel('initLC-NorthChina');
  static const platformEastChina = MethodChannel('initLC-EastChina');
  static const platformUS = MethodChannel('initLC-US');
  static const platformTDS = MethodChannel('initTDS');
  static const platformTest = MethodChannel('init-Test');

  String _userIfLeancloud = 'LeanCloud 华北员工';
  final _formKey = GlobalKey<FormState>();
  String _userName, _password;
  bool _isObscure = true;
  Color _eyeColor;
  bool _userProtocolSelected = false;
  bool _privacySelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    saveProfile();
    Future.delayed(Duration.zero, () {
      isFirstLaunch();
    });
  }

  void isFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isAgree = prefs.getBool('isAgree');
    //第一次弹窗通知
    if (isAgree == false || isAgree == null) {
      showProtocolDialogPage();
    }
  }

  showProtocolDialogPage() {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new ProtocolDialog(),
      ),
    );
  }

  void saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('username');
    String userType = prefs.getString('userType');
    String password = prefs.getString('password');

    if (userType != null || userType != '') {
      setState(() {});
    }

    if (name != null) {
      _controllerName.text = name;
    }
    if (password != null) {
      _controllerPassword.text = password;
    }
    if (userType != null) {
      _userIfLeancloud = userType;
    }
  }

  Future userLogin(String name, String password) async {
    CommonUtil.showLoadingDialog(context); //发起请求前弹出loading

    initLeanCloud().then((response) {
      saveUserType(this._userIfLeancloud);
      saveUserProfile();
      login(name, password).then((value) {
        Navigator.pop(context); //销毁 loading
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(builder: (context) => HomeBottomBarPage()),
            (_) => false);
      }).catchError((error) {
        showToastRed(error.message);
        print(error.message);
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
                buildForgetPasswordText(context),
                SizedBox(height: 60.0),
                buildUserProtocol(context),
                buildPrivacy(context),
                buildLoginButton(context),
                SizedBox(height: 30.0),
                buildRegisterText(context),
              ],
            )));
  }

  Align buildRegisterText(BuildContext context) {
    Align content;
    // if (_userIfLeancloud == 'LeanCloud 员工') {
    //   content = Align(
    //     alignment: Alignment.center,
    //     child: new Container(height: 0.0, width: 0.0),
    //   );
    // } else {
    content = Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('没有账号？'),
            GestureDetector(
              child: Text(
                '点击注册',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                //跳转到注册页面
                Navigator.pushAndRemoveUntil(
                    context,
                    new MaterialPageRoute(builder: (context) => SignUpPage()),
                    (_) => false);
              },
            ),
          ],
        ),
      ),
    );
    // }
    return content;
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            'Login',
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
          color: Colors.black,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              //只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              if (!_privacySelected || !_userProtocolSelected) {
                showToastRed('未同意用户使用协议或者隐私政策');
              } else {
                userLogin(_userName, _password);
              }
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
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
            items: <String>[
              'LeanCloud 华北员工',
              'LeanCloud 华东员工',
              'LeanCloud 国际员工',
              'TDS 员工',
              '其他区员工'
            ].map<DropdownMenuItem<String>>((String value) {
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

  Padding buildForgetPasswordText(BuildContext context) {
    Padding content;
    // if (_userIfLeancloud == '游客登录') {
    //   content = Padding(
    //     padding: const EdgeInsets.only(top: 8.0),
    //     child: new Container(height: 0.0, width: 0.0),
    //   );
    // } else {
    content = Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
          child: Text(
            '忘记密码？',
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          onPressed: () {
            showToastGreen('可以去控制台重置密码');
          },
        ),
      ),
    );
    // }
    return content;
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: _controllerPassword,
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

  TextFormField buildEmailTextField() {
    return TextFormField(
      controller: _controllerName,
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
            'LeanCloud Login',
            style: TextStyle(fontSize: 28.0),
          ),
        ));
  }

  Padding buildPrivacy(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            value: _privacySelected,
            activeColor: Colors.blue, //选中时的颜色
            onChanged: (value) {
              setState(() {
                _privacySelected = value;
              });
            },
          ),
          GestureDetector(
            child: Text(
              '我已阅读并同意隐私政策',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 15.0,
              ),
            ),
            onTap: () => showPrivacyPage(),
          )
        ],
      ),
    );
  }

  Padding buildUserProtocol(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            value: _userProtocolSelected,
            activeColor: Colors.blue, //选中时的颜色
            onChanged: (value) {
              setState(() {
                _userProtocolSelected = value;
              });
            },
          ),
          GestureDetector(
            child: Text(
              '我已阅读并同意用户使用协议',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 15.0,
              ),
            ),
            onTap: () => showUserProtocolPage(),
          )
        ],
      ),
    );
  }

  Future login(String name, String password) async {
    LCUser user = await LCUser.login(name, password);
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

  Future initLeanCloud() async {
    if (_userIfLeancloud == 'LeanCloud 华北员工') {
      LeanCloud.initialize(
          'eLAwFuK8k3eIYxh29VlbHu2N-gzGzoHsz', 'G59fl4C1uLIQVR4BIiMjxnM3',
          server: 'https://elawfuk8.lc-cn-n1-shared.com',
          queryCache: new LCQueryCache());
    } else if (_userIfLeancloud == 'LeanCloud 华东员工') {
      LeanCloud.initialize(
          '2ke9qjLSGeamYyU7dT6eqvng-9Nh9j0Va', 'FEttS9MjIXgmyvbslSp90aUI',
          server: 'https://2ke9qjls.lc-cn-e1-shared.com',
          queryCache: new LCQueryCache());
    } else if (_userIfLeancloud == 'LeanCloud 国际员工') {
      LeanCloud.initialize('glvame9g0qlj3a4o29j5xdzzrypxvvb30jt4vnvm66klph4r',
          'n79rw9ja3eo8n8au838t7pqur5mw88pnnep6ahlr99iq661a',
          server: 'https://usfcm.goodluckin.top',
          queryCache: new LCQueryCache());
    } else if (_userIfLeancloud == 'TDS 员工') {
      LeanCloud.initialize(
          'HoiGvMeacbPWnv12MK', 'FesqQUmlhjMWt6uNrKaV6QPtYgBYZMP9QFmTUk54',
          server: 'https://hoigvmea.cloud.tds1.tapapis.cn',
          queryCache: new LCQueryCache());
    } else if (_userIfLeancloud == '其他区员工') {
      //其他区员工，测试区账号
      LeanCloud.initialize(
          '6HKynQEeIYeWpHmF9e7ocY5R-TeStHjQi', 'FLx5kVKBU04k6SxmuIVndMNy',
          server: 'https://api.uc-test1.leancloud.cn',
          queryCache: new LCQueryCache());

      // 在 LeanCloud.initialize 初始化之后执行
      LCLogger.setLevel(LCLogger.DebugLevel);
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
    } else if (usertype == 'LeanCloud 国际员工') {
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
    } else if (usertype == '其他区员工') {
      try {
        await platformTest.invokeMethod('init-Test');
      } on PlatformException catch (e) {
        showToastRed("Android 原生 SDK 初始化失败");
      }
    }
  }

  Future saveUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', this._controllerName.text);
    await prefs.setString('password', this._controllerPassword.text);
  }
}
