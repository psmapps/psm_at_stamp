import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';

void signInWithLinePlatformExceptionHandler(BuildContext context,
    {@required PlatformException exception}) {
  logger.d(exception);
  switch (exception.code) {
    case "CANCEL":
      return;
      break;
    case "3003":
      return;
      break;
    case "PLATFORM_UNSUPPORTED":
      showMessageBox(
        context,
        title: "Platform ไม่รองรับ",
        content:
            "การเข้าสู่ระบบด้วย LINE บน PSM @ STAMP รองรับบนระบบปฏิบัติการ iOS และ Android เท่านั้น",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red,
      );
      break;
    case "INCORRECT_JWT_FORMAT":
      showMessageBox(
        context,
        title: "เกิดข้อผิดพลาด",
        content:
            "เกิดข้อผิดพลาด ข้อมูลบางส่วนไม่สมบูรณ์ กรุณาลองใหม่อีกครั้ง (Code: INCORRECT_JWT_FORMAT)",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red,
      );
      break;
    case "NO_EMAIL_IN_IDTOKEN":
      showMessageBox(
        context,
        title: "กรุณาอนุญาติการเข้าถึงที่อยู่ Email",
        content:
            "PSM @ STAMP จำเป็นต้องใช้ Email ของคุณในการยืนยันตัวตน เราจะไม่เปิดเผย Email ให้กับบุคคลที่ไม่เกี่ยวข้อง กรุณาอนุญาติการเข้าถึงที่อยู่ Email ของคุณจาก LINE",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red,
      );
      break;
    case "AUTHENTICATION_AGENT_ERROR":
      break;
    default:
      showMessageBox(
        context,
        title: "เกิดข้อผิดพลาดไม่ทราบสาเหตุ",
        content:
            "เกิดข้อผิดพลาดระหว่างการเข้าสู่ระบบด้วย LINE กรุณาลองใหม่อีกครั้ง (Code: ${exception.code})",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red,
      );
  }
}
