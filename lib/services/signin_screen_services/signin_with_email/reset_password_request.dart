import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_component/loading_box.dart';
import 'package:psm_at_stamp/components/notification_component/message_box.dart';

Future<void> resetPasswordRequest(BuildContext context,
    {@required String email}) async {
  if (email == "" || email == null) {
    return showMessageBox(
      context,
      title: "กรอกข้อมูลให้ครบถ้วน",
      content: "กรุณากรอกที่อยู่ Email เพื่อทำการส่งคำขอ",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
  showLoadingBox(context, loadingMessage: "กำลังส่งคำขอ");
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    Navigator.pop(context);
    return showMessageBox(context,
        title: "ส่งคำขอการ Reset Password สำเร็จ",
        content:
            "คำขอการ Reset Password ได้ถูกส่งไปยัง Email ของคุณแล้ว กรุณาทำตามขั้นตอนใน Email เพื่อทำการเปลี่ยนรหัสผ่าน",
        icon: FontAwesomeIcons.infoCircle,
        iconColor: Colors.green,
        actionsButton: [
          IconButton(
            icon: Icon(FontAwesomeIcons.timesCircle),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          )
        ]);
  } on PlatformException catch (e) {
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        Navigator.pop(context);
        return showMessageBox(
          context,
          title: "ที่อยู่ Email ไม่ถูกรูปแบบ",
          content: "กรุณากรอก Email ให้ตรงตามรูปแบบ เช่น example@psmapps.com",
          icon: FontAwesomeIcons.exclamationTriangle,
          iconColor: Colors.yellow,
        );
        break;
      case "ERROR_USER_NOT_FOUND":
        Navigator.pop(context);
        return showMessageBox(
          context,
          title: "ที่อยู่ Email ไม่ถูกต้อง",
          content:
              "Email ที่คุณระบุมายังไม่เคยถูกสมัครใช้งาน PSM @ STAMP กรุณาตรวจสอบความถูกต้องและลองใหม่อีกครั้ง",
          icon: FontAwesomeIcons.exclamationCircle,
          iconColor: Colors.red,
        );
        break;
    }
  }
}
