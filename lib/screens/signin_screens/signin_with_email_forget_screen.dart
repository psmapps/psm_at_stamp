import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/button_components/app_button_components.dart';
import 'package:psm_at_stamp/components/signin_textfield_components.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_with_email/reset_password_request.dart';

class SignInWithEmailForgetPassword extends StatefulWidget {
  SignInWithEmailForgetPassword({Key key}) : super(key: key);

  @override
  _SignInWithEmailForgetPasswordState createState() =>
      _SignInWithEmailForgetPasswordState();
}

class _SignInWithEmailForgetPasswordState
    extends State<SignInWithEmailForgetPassword> {
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 31, 31, 1),
      appBar: AppBar(
        title: Text(
          "เปลี่ยนรหัสผ่าน",
          style: TextStyle(fontFamily: "Sukhumwit"),
        ),
        backgroundColor: Color.fromRGBO(40, 40, 40, 1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text(
                "เปลี่ยนรหัสผ่านบัญชี",
                style: TextStyle(
                  fontFamily: "Sukhumwit",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "กรุณากรอก Email ที่คุณใช้ลงทะเบียน",
                style: TextStyle(
                  fontFamily: "Sukhumwit",
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "** หากคุณจำ Email ไม่ได้ กรุณาติดต่อ PSM @ STAMP Team **",
                style: TextStyle(
                  fontFamily: "Sukhumwit",
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              signInTextField(
                controller: email,
                labelText: "Email",
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
              ),
              appButtonComponent(
                title: "ส่งคำขอเปลี่ยนรหัส",
                onPressHandler: () {
                  resetPasswordRequest(context, email: email.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
