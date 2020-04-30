import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/screens/setting_screens/setting_screen.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';

Future<void> scanQrCode(BuildContext context) async {
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
                MaterialPageRoute(builder: (context) => SettingScreen()),
              );
            },
          ),
        ]);
  }
  ScanResult result;
  try {
    result = await BarcodeScanner.scan(
      options: ScanOptions(
        useCamera: -1,
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
  logger.d(result.rawContent);
}
