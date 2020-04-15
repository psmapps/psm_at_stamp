import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_component/loading_box.dart';
import 'package:psm_at_stamp/components/notification_component/message_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';

Future<void> signInWithLine(BuildContext context) async {
  showLoadingBox(context, loadingMessage: "กำลังเข้าสู่ระบบด้วย LINE");
  LoginResult lineLoginResult;
  try {
    lineLoginResult =
        await LineSDK.instance.login(scopes: ["profile", "openid", "email"]);
  } on PlatformException catch (e) {
    Navigator.pop(context);
    logger.d(e);
    switch (e.code) {
      case "CANCEL":
        return;
        break;
      default:
        showMessageBox(
          context,
          title: "เกิดข้อผิดพลาดไม่ทราบสาเหตุ",
          content:
              "เกิดข้อผิดพลาดระหว่างการเข้าสู่ระบบด้วย LINE กรุณาลองใหม่อีกครั้ง (Code: ${e.code})",
          icon: FontAwesomeIcons.exclamationCircle,
          iconColor: Colors.red,
        );
    }
    return;
  }
  Navigator.pop(context);
  logger.d(lineLoginResult);
}
