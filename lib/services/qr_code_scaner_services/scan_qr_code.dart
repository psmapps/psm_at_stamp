import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/loading_box.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/qr_code_scaner_services/qr_code_type_stamp_handler.dart';
import 'package:psm_at_stamp/services/qr_code_scaner_services/qr_code_type_user_handler.dart';

Future<void> scanQrCode(
  BuildContext context, {
  @required PsmAtStampUser psmAtStampUser,
  @required String result,
}) async {
  logger.d(result);
  Map<String, dynamic> qrCodeData;
  showLoadingBox(context, loadingMessage: "กำลังตรวจสอบ QR Code");
  try {
    qrCodeData = json.decode(result);
    if (qrCodeData["type"] == null || qrCodeData["type"] == "") {
      throw PlatformException(
        code: "QRNOTCORRECT",
        details: "QR Code ไม่ถูกต้อง",
        message:
            "กรุณาสแกน QR Code ที่มีโลโก้ PSM @ STAMP อยู่ตรงกลางของ QR Code เท่านั้น",
      );
    }

    switch (qrCodeData["type"]) {
      case "user":
        if (qrCodeData["userId"] == null || qrCodeData["userId"] == "") {
          throw PlatformException(
            code: "QRNOTCORRECT",
            details: "QR Code ไม่ถูกต้อง",
            message:
                "กรุณาสแกน QR Code ที่มีโลโก้ PSM @ STAMP อยู่ตรงกลางของ QR Code เท่านั้น",
          );
        }
        qrCodeTypeUserHandler(
          context,
          qrCodeData: qrCodeData,
          psmAtStampUser: psmAtStampUser,
        );
        break;
      case "stamp":
        if (qrCodeData["token"] == null || qrCodeData["token"] == "") {
          throw PlatformException(
            code: "QRNOTCORRECT",
            details: "QR Code ไม่ถูกต้อง",
            message:
                "กรุณาสแกน QR Code ที่มีโลโก้ PSM @ STAMP อยู่ตรงกลางของ QR Code เท่านั้น",
          );
        }
        qrCodeTypeStampHandler(
          context,
          qrCodeData: qrCodeData,
          psmAtStampUser: psmAtStampUser,
        );
        break;
      default:
        throw PlatformException(
          code: "QRNOTCORRECT",
          details: "QR Code ไม่ถูกต้อง",
          message:
              "กรุณาสแกน QR Code ที่มีโลโก้ PSM @ STAMP อยู่ตรงกลางของ QR Code เท่านั้น",
        );
    }
  } catch (e) {
    Navigator.pop(context);
    throw PlatformException(
      code: "QRNOTCORRECT",
      details: "QR Code ไม่ถูกต้อง",
      message:
          "กรุณาสแกน QR Code ที่มีโลโก้ PSM @ STAMP อยู่ตรงกลางของ QR Code เท่านั้น",
    );
  }
}
