import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_component/message_box.dart';
import 'package:psm_at_stamp/screens/register_screens/register_screen_select_role.dart';
import 'package:psm_at_stamp/services/register_services/psmatstampregister_constructure.dart';

void signUserInErrorHandler(BuildContext context,
    {@required PlatformException exception,
    PsmAtStampRegister psmAtStampRegister}) {
  switch (exception.code) {
    case "ACCOUNT_DATA_INVALID":
      showMessageBox(context,
          title: "ไม่สามารถเข้าสู่ระบบได้",
          content:
              "บัญชีของคุณมีข้อผิดพลาดบางส่วน กรุณาติดต่อ PSM @ STAMP Team และแจ้งรหัสนักเรียนของคุณพร้อมกับ ERR_CODE นี้ เพื่อดำเนินการแก้ไขต่อไป (ERR_CODE: ACCOUNT_DATA_INVALID)",
          icon: FontAwesomeIcons.exclamationTriangle,
          iconColor: Colors.yellow);
      break;
    case "UNKNOWN_PERMISSION":
      showMessageBox(context,
          title: "ไม่สามารถเข้าสู่ระบบได้",
          content:
              "บัญชีของคุณมีข้อผิดพลาดบางส่วน กรุณาติดต่อ PSM @ STAMP Team และแจ้งรหัสนักเรียนของคุณพร้อมกับ ERR_CODE นี้ เพื่อดำเนินการแก้ไขต่อไป (ERR_CODE: UNKNOWN_PERMISSION)",
          icon: FontAwesomeIcons.exclamationTriangle,
          iconColor: Colors.yellow);
      break;
    case "ACCOUNT_NOT_FOUND":
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RegisterSelectRole(psmAtStampRegister: psmAtStampRegister),
        ),
      );
      showMessageBox(
        context,
        title: "ยินดีต้อนรับเข้าสู่ PSM @ STAMP",
        content:
            "กรุณาผูกบัญชีกับรหัสนักเรียนของคุณ การผูกบัญชีจะทำแค่ครั้งแรกเพียงครั้งเดียว",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.greenAccent,
      );
      break;
  }
}
