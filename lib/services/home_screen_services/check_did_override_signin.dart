import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

Future<void> checkDidOverrideSignIn(BuildContext context,
    {@required PsmAtStampUser psmAtStampUser}) {
  logger.d("didOverrideSignInCheck: " +
          psmAtStampUser.otherInfos["didOverrideSignIn"].toString() ??
      "NULL");
  return Future.delayed(
    Duration(seconds: 1),
    () {
      if (psmAtStampUser.otherInfos["didOverrideSignIn"] ?? false) {
        showMessageBox(
          context,
          title: "การเข้าสู่ระบบซ้ำ",
          content:
              "การเข้าสู่ระบบนี้จะทำให้คุณออกจากระบบในอุปกรณ์เก่าโดยอัตโนมัติ เนื่องจากผู้ใช้งานสามารถเข้าสู่ระบบได้จากอุปกรณ์เครื่องเดียวเท่านั้น",
          icon: FontAwesomeIcons.exclamationTriangle,
          iconColor: Colors.yellow[600],
        );
      }
    },
  );
}
