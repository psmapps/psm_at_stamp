import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

void qrCodeTypeUserHandler(BuildContext context,
    {@required Map<String, dynamic> qrCodeData,
    @required PsmAtStampUser psmAtStampUser}) {
  if (psmAtStampUser.permission != PsmAtStampUserPermission.administrator) {
    Navigator.pop(context);
    return showMessageBox(
      context,
      title: "QR Code นี้ไม่ใช่ Stamp QR Code",
      content:
          "​QR Code นี้เป็น User QR Code. กรุณาสแกน QR Code จากพี่ฐานกิจกรรมต่างๆ เพื่อรับแสตมป์",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
  //TODO: Navigate to administrator page!
  logger.d("Administrator Member Page");
}