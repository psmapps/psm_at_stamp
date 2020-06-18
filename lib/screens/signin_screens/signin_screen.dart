import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:psm_at_stamp/components/button_components/app_button_components.dart';
import 'package:psm_at_stamp/components/button_components/signin_icon_only_button.dart';
import 'package:psm_at_stamp/screens/signin_screens/signin_with_email_screen.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_with_apple/signin_with_apple.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_with_google/signin_with_google.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_with_line/signin_with_line.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String version = "-";
  String buildNumber = "-";
  @override
  void initState() {
    getPackageInfo();
    super.initState();
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 30, 30, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/animation/psmatstampintro.gif",
                        scale: 3.7,
                      ),
                      Text(
                        "ยินดีต้อนรับเข้าสู่ PSM @ STAMP",
                        style: TextStyle(
                            color: Color.fromRGBO(225, 223, 26, 1),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "กรุณาเข้าสู่ระบบก่อนเริ่มต้นใช้งาน",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        "Version " + version + " (Build: " + buildNumber + ")",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      appButtonComponent(
                        title: "ลงชื่อเข้าด้วย Email",
                        icon: Icons.email,
                        onPressHandler: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInWithEmailScreen(),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 20.0,
                                ),
                                child: Divider(
                                  color: Colors.white,
                                  height: 36,
                                )),
                          ),
                          Text(
                            "เข้าสู่ระบบด้วยวิธีอื่น",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 10.0,
                                ),
                                child: Divider(
                                  color: Colors.white,
                                  height: 36,
                                )),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                      ),
                      Row(
                        children: <Widget>[
                          signInIconOnlyButton(
                            svgAsset: "assets/images/button_icons/google.svg",
                            buttonColor: Colors.white,
                            onPressed: () {
                              signInWithGoogle(context);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                          ),
                          signInIconOnlyButton(
                            svgAsset:
                                "assets/images/button_icons/line_white.svg",
                            buttonColor: Color.fromRGBO(0, 176, 3, 1),
                            onPressed: () {
                              signInWithLine(context);
                            },
                          ),
                          Platform.isIOS
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                )
                              : Container(),
                          Platform.isIOS
                              ? signInIconOnlyButton(
                                  svgAsset:
                                      "assets/images/button_icons/apple.svg",
                                  buttonColor: Colors.white,
                                  onPressed: () {
                                    signInWithApple(context);
                                  },
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
