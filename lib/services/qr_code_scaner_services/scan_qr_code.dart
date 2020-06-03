import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/loading_box.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/qr_code_scaner_services/qr_code_type_stamp_handler.dart';
import 'package:psm_at_stamp/services/qr_code_scaner_services/qr_code_type_user_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

Future<void> scanQrCode(
  BuildContext context, {
  @required PsmAtStampUser psmAtStampUser,
  @required String result,
  @required QRViewController controller,
}) async {
  logger.d(result);
  Map<String, dynamic> qrCodeData;
  showLoadingBox(context, loadingMessage: "กำลังตรวจสอบ QR Code");
  try {
    qrCodeData = json.decode(result);
    if (qrCodeData["type"] == null || qrCodeData["type"] == "") {
      showMessageBox(
        context,
        title: "QR Code ไม่ถูกต้อง",
        content:
            "กรุณาสแกน QR Code ที่มีโลโก้ PSM @ STAMP อยู่ตรงกลางของ QR Code เท่านั้น",
        icon: FontAwesomeIcons.exclamationTriangle,
        iconColor: Colors.yellow,
        actionsButton: [
          IconButton(
            icon: Icon(FontAwesomeIcons.timesCircle),
            onPressed: () {
              Navigator.pop(context);
              controller.resumeCamera();
            },
          )
        ],
      );
    }

    switch (qrCodeData["type"]) {
      case "user":
        if (qrCodeData["userId"] == null || qrCodeData["userId"] == "") {
          showMessageBox(
            context,
            title: "QR Code ไม่ถูกต้อง",
            content:
                "กรุณาสแกน QR Code ที่มีโลโก้ PSM @ STAMP อยู่ตรงกลางของ QR Code เท่านั้น",
            icon: FontAwesomeIcons.exclamationTriangle,
            iconColor: Colors.yellow,
            actionsButton: [
              IconButton(
                icon: Icon(FontAwesomeIcons.timesCircle),
                onPressed: () {
                  Navigator.pop(context);
                  controller.resumeCamera();
                },
              )
            ],
          );
        }
        qrCodeTypeUserHandler(
          context,
          qrCodeData: qrCodeData,
          psmAtStampUser: psmAtStampUser,
          controller: controller,
        );
        break;
      case "stamp":
        if (qrCodeData["token"] == null || qrCodeData["token"] == "") {
          showMessageBox(
            context,
            title: "QR Code ไม่ถูกต้อง",
            content:
                "กรุณาสแกน QR Code ที่มีโลโก้ PSM @ STAMP อยู่ตรงกลางของ QR Code เท่านั้น",
            icon: FontAwesomeIcons.exclamationTriangle,
            iconColor: Colors.yellow,
            actionsButton: [
              IconButton(
                icon: Icon(FontAwesomeIcons.timesCircle),
                onPressed: () {
                  Navigator.pop(context);
                  controller.resumeCamera();
                },
              )
            ],
          );
        }
        qrCodeTypeStampHandler(
          context,
          qrCodeData: qrCodeData,
          psmAtStampUser: psmAtStampUser,
          controller: controller,
        );
        break;
      default:
        showMessageBox(
          context,
          title: "QR Code ไม่ถูกต้อง",
          content:
              "กรุณาสแกน QR Code ที่มีโลโก้ PSM @ STAMP อยู่ตรงกลางของ QR Code เท่านั้น",
          icon: FontAwesomeIcons.exclamationTriangle,
          iconColor: Colors.yellow,
          actionsButton: [
            IconButton(
              icon: Icon(FontAwesomeIcons.timesCircle),
              onPressed: () {
                Navigator.pop(context);
                controller.resumeCamera();
              },
            )
          ],
        );
    }
  } catch (e) {
    Navigator.pop(context);
    showMessageBox(
      context,
      title: "QR Code ไม่ถูกต้อง",
      content:
          "กรุณาสแกน QR Code ที่มีโลโก้ PSM @ STAMP อยู่ตรงกลางของ QR Code เท่านั้น",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
      actionsButton: [
        IconButton(
          icon: Icon(FontAwesomeIcons.timesCircle),
          onPressed: () {
            Navigator.pop(context);
            controller.resumeCamera();
          },
        )
      ],
    );
  }
}
