import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psm_at_stamp/components/notification_components/loading_box.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/screens/setting_screens/setting_screen.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/qr_code_scaner_services/qr_code_type_stamp_handler.dart';
import 'package:psm_at_stamp/services/qr_code_scaner_services/qr_code_type_user_handler.dart';
import 'package:psm_at_stamp/services/setting_services/get_camera_setting_file.dart';

Future<void> scanQrCode(BuildContext context,
    {@required PsmAtStampUser psmAtStampUser}) async {
  await Permission.camera.request();
  if (!(await Permission.camera.isGranted)) {
    return showMessageBox(context,
        title: "ยังไม่ได้อนุญาตการใช้กล้อง",
        content:
            "คุณยังไม่ได้อนุญาตการใช้กล้องให้กับ PSM @ STAMP การใช้กล้องจำเป็นต่อการ Scan QR Code กรุณาอนุญาตการใช้กล้องด้วยการไปที่หน้า ตั้งค่า ก่อน",
        icon: FontAwesomeIcons.exclamationTriangle,
        iconColor: Colors.yellow,
        actionsButton: [
          IconButton(
            icon: Icon(FontAwesomeIcons.timesCircle),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.cog),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingScreen(
                    psmAtStampUser: psmAtStampUser,
                  ),
                ),
              );
            },
          ),
        ]);
  }
  ScanResult result;
  try {
    result = await BarcodeScanner.scan(
      options: ScanOptions(
        useCamera: int.parse((await getCameraSetting())["camera"]),
        android: AndroidOptions(
          useAutoFocus: true,
        ),
        strings: {
          "cancel": "< กลับไปยังแอพ",
          "flash_on": "เปิด Flash",
          "flash_off": "ปิด Flash"
        },
      ),
    );
  } on FormatException {
    return;
  } catch (e) {
    return showMessageBox(
      context,
      title: "เกิดข้อผิดพลาด",
      content:
          "เกิดข้อผิดพลาดระหว่างการ Scan QR Code โดยไม่ทราบสาเหตุ กรุณาลองใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.redAccent,
    );
  }
  if (result.rawContent == "" || result.rawContent == null) {
    return;
  }
  logger.d(result.rawContent);
  Map<String, dynamic> qrCodeData;
  showLoadingBox(context, loadingMessage: "กำลังตรวจสอบ QR Code");
  try {
    qrCodeData = json.decode(result.rawContent);
    if (qrCodeData["type"] == null || qrCodeData["type"] == "") {
      throw "Type not correct";
    }

    switch (qrCodeData["type"]) {
      case "user":
        if (qrCodeData["userId"] == null || qrCodeData["userId"] == "") {
          throw "Type not correct";
        }
        qrCodeTypeUserHandler(
          context,
          qrCodeData: qrCodeData,
          psmAtStampUser: psmAtStampUser,
        );
        break;
      case "stamp":
        if (qrCodeData["token"] == null || qrCodeData["token"] == "") {
          throw "Type not correct";
        }
        qrCodeTypeStampHandler(
          context,
          qrCodeData: qrCodeData,
          psmAtStampUser: psmAtStampUser,
        );
        break;
      default:
        throw "Type not correct";
    }
  } catch (e) {
    Navigator.pop(context);
    return showMessageBox(
      context,
      title: "QR Code ไม่ถูกต้อง",
      content:
          "กรุณาสแกน QR Code ที่มีโลโก้ PSM @ STAMP อยู่ตรงกลางของ QR Code เท่านั้น",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
}
