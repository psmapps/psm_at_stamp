import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/button_components/app_button_components.dart';
import 'package:psm_at_stamp/screens/register_screens/register_screen_input_studentId.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/register_services/psmatstampregister_constructure.dart';

class RegisterSelectRole extends StatelessWidget {
  // psmAtStampRegister has these data
  // [userId, profileImage, displayName, email, signInServices]
  final PsmAtStampRegister psmAtStampRegister;
  const RegisterSelectRole({Key key, @required this.psmAtStampRegister})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 31, 31, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(40, 40, 40, 1),
        title: Text(
          "เลือกรูปแบบของบัญชี",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                child: Center(
                  child: Image.asset(
                    "assets/images/icons/icon.png",
                    scale: 5,
                  ),
                ),
              ),
              Text(
                "ยินดีต้อนรับเข้าสู่การผูกบัญชี",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
              ),
              Text(
                "การผูกบัญชีคือการผูกบัญชีที่ใช้เข้าสู่ระบบกับรหัสนักเรียนของคุณ โดยจะทำเพียงครั้งแรกครั้งเดียว และ รหัสนักเรียน 1 รหัส จะสามารถผูกได้ 1 ครั้งเท่านั้น",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
              ),
              Text(
                "กรุณาเลือกรูปแบบบัญชีที่คุณต้องการผูก",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              appButtonComponent(
                title: "ฉันเป็นนักเรียน",
                icon: Icons.account_box,
                onPressHandler: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(
                        psmAtStampRegister: new PsmAtStampRegister(
                          userId: psmAtStampRegister.userId,
                          email: psmAtStampRegister.email,
                          profileImage: psmAtStampRegister.profileImage,
                          displayName: psmAtStampRegister.displayName,
                          permission: PsmAtStampUserPermission.student,
                          signInServices: psmAtStampRegister.signInServices,
                        ),
                      ),
                    ),
                  );
                },
              ),
              appButtonComponent(
                title: "ฉันเป็นพี่ดูแลฐานกิจกรรม",
                icon: FontAwesomeIcons.solidBookmark,
                onPressHandler: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(
                        psmAtStampRegister: new PsmAtStampRegister(
                          userId: psmAtStampRegister.userId,
                          email: psmAtStampRegister.email,
                          profileImage: psmAtStampRegister.profileImage,
                          displayName: psmAtStampRegister.displayName,
                          permission: PsmAtStampUserPermission.staff,
                          signInServices: psmAtStampRegister.signInServices,
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
