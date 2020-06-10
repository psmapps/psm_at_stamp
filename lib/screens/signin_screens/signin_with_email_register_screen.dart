import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/button_components/app_button_components.dart';
import 'package:psm_at_stamp/components/signin_textfield_components.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_with_email/register_with_email.dart';

class SignInWithEmailRegisterScreen extends StatefulWidget {
  SignInWithEmailRegisterScreen({Key key}) : super(key: key);

  @override
  _SignInWithEmailRegisterScreenState createState() =>
      _SignInWithEmailRegisterScreenState();
}

class _SignInWithEmailRegisterScreenState
    extends State<SignInWithEmailRegisterScreen> {
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  TextEditingController rePasswordText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(31, 31, 31, 1),
        appBar: AppBar(
          title: Text(
            "สมัครบัญชีด้วย Email/Password",
            style: TextStyle(fontFamily: "Sukhumwit"),
          ),
          backgroundColor: Color.fromRGBO(40, 40, 40, 1),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Text(
                  "กรุณากรอกที่อยู่ Email และ Password สำหรับบัญชี PSM @ STAMP ของคุณ",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Sukhumwit",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                signInTextField(
                  controller: emailText,
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                signInTextField(
                  controller: passwordText,
                  labelText: "Password",
                  isObsecureText: true,
                ),
                signInTextField(
                  controller: rePasswordText,
                  labelText: "Re-Password",
                  isObsecureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                ),
                appButtonComponent(
                    title: "สมัครบัญชี",
                    onPressHandler: () {
                      registerWithEmail(
                        context,
                        email: emailText.text,
                        password: passwordText.text,
                        rePassword: rePasswordText.text,
                      );
                    })
              ],
            ),
          ),
        ));
  }
}
