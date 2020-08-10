import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';

void signInPlatformExceptionHandler(
    BuildContext context, PlatformException exception) {
  logger.d(exception);
  switch (exception.code) {
    case "ERROR_WRONG_PASSWORD":
      return showMessageBox(
        context,
        title: "Email หรือ Password ไม่ถูกต้อง",
        content:
            "ไม่พบ Email ที่ผูกกับบัญชีนี้ หรือ Password ไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red,
      );
      break;
    case "ERROR_USER_NOT_FOUND":
      showMessageBox(
        context,
        title: "Email หรือ Password ไม่ถูกต้อง",
        content:
            "ไม่พบ Email ที่ผูกกับบัญชีนี้ หรือ Password ไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red,
      );
      break;
    case "ERROR_INVALID_EMAIL":
      showMessageBox(
        context,
        title: "Email ไม่ถูกต้อง",
        content:
            "กรุณาใส่ Email ให้ถูกต้องตามโครงสร้างของ Email (เช่น example@psmapps.com)",
        icon: FontAwesomeIcons.exclamationTriangle,
        iconColor: Colors.yellow,
      );
      break;
    case "ERROR_TOO_MANY_REQUESTS":
      showMessageBox(
        context,
        title: "การเข้าสู่ระบบถูกระงับ",
        content:
            "คุณมีการเข้าสู่ระบบหลายครั้งติดต่อกันเป็นจำนวนมาก กรุณาลองใหม่อีกครั้งในอีก 30 นาที",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red,
      );
      break;
    case "ERROR_USER_DISABLED":
      showMessageBox(
        context,
        title: "บัญชีถูกระงับ",
        content:
            "บัญชีของคุณถูกระงับการใช้งานชั่วคราว หากคิดว่านี้เป็นข้อผิดพลาด กรุณาติดต่่อ PSM @ STAMP Team",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red,
      );
      break;
    case "ERROR_OPERATION_NOT_ALLOWED":
      showMessageBox(
        context,
        title: "เกิดข้อผิดพลาดระหว่างการเข้าสู่ระบบ",
        content:
            "เกิดข้อผิดพลาดของ PSM @ STAMP กรุณาลองใหม่อีกครั้งในอีกซักครู่ หรือ ติดต่อ PSM @ STAMP Team เพื่อแจ้งเรื่องนี้",
        icon: FontAwesomeIcons.exclamationTriangle,
        iconColor: Colors.yellow,
      );
      break;
    case "ApiException":
      showMessageBox(
        context,
        title: "ไม่สามารถติดต่อ Google ได้",
        content: "กรุณาตรวจสอบการเชื่อมต่อของคุณ และลองใหม่อีกครั้ง",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red,
      );
      break;
    case "ERROR_WEAK_PASSWORD":
      showMessageBox(
        context,
        title: "Password ของคุณง่ายเกินไป",
        content:
            "Password ของคุณสามารถคาดเดาได้ง่าย กรุณาตั้ง Password บัญชีของคุณใหม่อีกครั้งเพื่อความปลอดภัยของบัญชี PSM @ STAMP ของคุณ",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red,
      );
      break;
    case "ERROR_EMAIL_ALREADY_IN_USE":
      showMessageBox(
        context,
        title: "Email นี้ถูกใช้งานไปแล้ว",
        content:
            "Email นี้เคยใช้เปิดบัญชีกับ PSM @ STMAP ไปแล้ว กรุณาเปลี่ยน Email หรือ ติดต่อ PSM @ STAMP Team หากต้องการความช่วยเหลือ",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red,
      );
      break;
    default:
      showMessageBox(
        context,
        title: "เกิดข้อผิดพลาดไม่ทราบสาเหตุ",
        content:
            "เกิดข้อผิดพลาดไม่ทราบสาเหตุ กรุณาลองใหม่อีกครั้ง (Code: ${exception.code})",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red,
      );
  }
}