import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/loading_box.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_platformexception_handler.dart';

Future<void> registerWithEmail(BuildContext context,
    {@required String email,
    @required String password,
    @required String rePassword}) async {
  if (email == "" || password == "" || rePassword == "") {
    return showMessageBox(
      context,
      title: "กรุณากรอกข้อมูลให้ครบถ้วน",
      content:
          "กรุณากรอกข้อมูลให้ครบถ้วน (Email, Password, Re-Password) ก่อนเริ่มลงทะเบียน",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
  if (password != rePassword) {
    return showMessageBox(
      context,
      title: "Password ไม่ตรงกัน",
      content:
          "Password และ Re-Password ไม่ต้องกัน กรุณาตรวจสอบข้อมูลให้ถูกต้องและลองใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
  showLoadingBox(context, loadingMessage: "กำลังสมัครบัญชี");
  AuthResult result;
  try {
    result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  } on PlatformException catch (e) {
    Navigator.pop(context);
    signInPlatformExceptionHandler(context, e);
  } catch (e) {
    Navigator.pop(context);
    logger.d(e);
    return showMessageBox(
      context,
      title: "เกิดข้อผิดพลาดไม่ทราบสาเหตุ",
      content: "เกิดข้อผิดพลาดโดยไม่ทราบสาเหตุ กรุณาลองใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
    );
  }
  await result.user.sendEmailVerification();
  Navigator.pop(context);
  showMessageBox(
    context,
    title: "การสมัครบัญชีสำเร็จ",
    content: "การสมัครบัญชีสำเร็จ เราได้ส่ง Email ไปที่ " +
        email +
        " เพื่อยืนยันที่อยู่ Email ของคุณ กรุณายืนยันที่อยู่ Email ตามขั้นตอน บัญชีของคุณจะยังไม่สามารถใช้งานได้หากไม่ยืนยันที่อยู่ Email",
    icon: FontAwesomeIcons.infoCircle,
    iconColor: Colors.green,
    actionsButton: [
      IconButton(
        icon: Icon(FontAwesomeIcons.timesCircle),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    ],
  );
}
