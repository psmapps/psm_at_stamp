import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
import 'package:psm_at_stamp/components/signin_textfield_components.dart';
import 'package:psm_at_stamp/screens/signin_screens/signin_with_email_forget_screen.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_with_email/signin_with_email.dart';

class SignInWithEmailScreen extends StatefulWidget {
  SignInWithEmailScreen({Key key}) : super(key: key);

  @override
  _SignInWithEmailScreenState createState() => _SignInWithEmailScreenState();
}

class _SignInWithEmailScreenState extends State<SignInWithEmailScreen> {
  var passwordFocus = new FocusNode();
  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(31, 31, 31, 1),
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Text(
                "เข้าสู่ระบบด้วย Email/Password",
                style: TextStyle(fontFamily: "Sukhumwit"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
              ),
              Icon(Icons.email),
            ],
          ),
          backgroundColor: Color.fromRGBO(40, 40, 40, 1),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: <Widget>[
                signInTextField(
                    controller: emailTextController,
                    labelText: "Email",
                    onSubmitted: (submitted) {
                      FocusScope.of(context).requestFocus(passwordFocus);
                    },
                    keyboardType: TextInputType.emailAddress),
                signInTextField(
                  controller: passwordTextController,
                  focusNode: passwordFocus,
                  labelText: "Password",
                  isObsecureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: signInButtonComponent(
                          title: "ลืมรหัสผ่าน",
                          onPressHandler: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SignInWithEmailForgetPassword(),
                              ),
                            );
                          },
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: signInButtonComponent(
                            title: "เข้าสู่ระบบ",
                            icon: Icons.account_circle,
                            onPressHandler: () {
                              signInWithEmail(
                                context,
                                email: emailTextController.text,
                                password: passwordTextController.text,
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "หรือ",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Sukhumwit",
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: signInButtonComponent(
                    title: "สมัครบัญชีด้วย Email",
                    onPressHandler: () {},
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
