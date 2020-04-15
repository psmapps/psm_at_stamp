import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 31, 31, 1),
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
                          "assets/images/icons/icon.png",
                          scale: 3.7,
                        ),
                        Text(
                          "ยินดีต้อนรับเข้าสู่ PSM @ STAMP",
                          style: TextStyle(
                              fontFamily: "Sukhumwit",
                              color: Color.fromRGBO(225, 223, 26, 1),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "กรุณาเข้าสู่ระบบก่อนเริ่มต้นใช้งาน",
                          style: TextStyle(
                            fontFamily: "Sukhumwit",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    )),
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        signInButtonComponent(
                          title: "เข้าสู่ระบบด้วย Google",
                          icon: FontAwesomeIcons.google,
                          onPressHandler: () {
                            signInWithGoogle(context);
                          },
                        ),
                        Platform.isIOS
                            ? signInButtonComponent(
                                title: "เข้าสู่ระบบด้วย Apple",
                                icon: FontAwesomeIcons.apple,
                                onPressHandler: () {
                                  signInWithApple(context);
                                },
                              )
                            : Container(),
                        signInButtonComponent(
                          title: "เข้าสู่ระบบด้วย LINE",
                          icon: FontAwesomeIcons.line,
                          onPressHandler: () {
                            signInWithLine(context);
                          },
                        ),
                        signInButtonComponent(
                          title: "เข้าสู่ระบบด้วย Email/Password",
                          icon: Icons.email,
                          onPressHandler: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SignInWithEmailScreen()));
                          },
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
