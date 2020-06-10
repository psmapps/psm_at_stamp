import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';

Future<void> qrCodeTypeStampHandler(
  BuildContext context, {
  @required Map<String, dynamic> qrCodeData,
  @required PsmAtStampUser psmAtStampUser,
  @required QRViewController controller,
}) async {
  const stampValidateApiUrl =
      "https://asia-east2-satitprasarnmit-psm-at-stamp.cloudfunctions.net/v4-stampValidate";

  logger.d(qrCodeData["token"]);
  http.Response response;
  var udid = await FlutterUdid.udid;
  try {
    response = await http.post(
      stampValidateApiUrl,
      headers: {
        "authorization": psmAtStampUser.accessToken,
      },
      body: {
        "userId": psmAtStampUser.userId,
        "udid": udid,
        "token": qrCodeData["token"]
      },
    ).timeout(Duration(seconds: 10));
  } catch (e) {
    logger.e(e);
    Navigator.pop(context);
    return showMessageBox(
      context,
      title: "เกิดข้อผิดพลาดไม่ทราบสาเหตุ",
      content:
          "ขออภัย เกิดข้อผิดพลาดไม่ทราบสาเหตุ อาจเป็นไปได้ว่า ไม่สามารถเชื่อมต่อกับ PSM @ STAMP ได้ กรุณาลองใหม่อีกครัง",
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
  logger.d(response.statusCode);
  logger.d(response.body);
  Navigator.pop(context);
  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = json.decode(response.body);
    return showMessageBox(
      context,
      title: "รับแสตมป์เรียบร้อย",
      content: "ยินดีด้วย คุณได้รับแสตมป์จากฐานกิจกรรม " +
          responseBody["stampDetail"]["name"] +
          " ในกลุ่มสาระ " +
          responseBody["stampDetail"]["categories"] +
          " เรียบร้อยแล้ว",
      icon: FontAwesomeIcons.infoCircle,
      iconColor: Colors.green,
      actionsButton: [
        IconButton(
          icon: Icon(FontAwesomeIcons.timesCircle),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        )
      ],
    );
  }
  switch (json.decode(response.body)["inAppStatusCode"]) {
    case "401-1":
      return showMessageBox(
        context,
        title: "เกิดข้อผิดพลาด",
        content:
            "ไม่สามารถยืนยันความถูกต้องของแสตมป์ได้ เป็นไปได้ว่าแสตมป์นี้หมดอายุแล้ว (1 แสตมป์จะมีอายุ 30 วินาที) กรุณาสแกน Stamp QR Code ใหม่จากพี่ฐานกิจกรรมอีกครั้ง",
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
      break;
    case "400":
      return showMessageBox(
        context,
        title: "เกิดข้อผิดพลาด",
        content:
            "QR Code ไม่ถูกต้อง กรุณาสแกน QR Code ที่มีโลโก้ PSM @ STAMP จากพี่ฐานกิจกรรมเท่านั้น",
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
      break;
    case "401-2":
      return showMessageBox(
        context,
        title: "เกิดข้อผิดพลาด",
        content:
            "คุณไม่สามารถรับแสตมป์ได้ กรุณาออกจากระบบ และเข้าสู่ระบบอีกครั้ง ก่อนทำการรับแสตมป์",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.redAccent,
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

      break;
    case "400-2":
      return showMessageBox(
        context,
        title: "เกิดข้อผิดพลาด",
        content:
            "คุณมีแสตมป์นี้อยู่ในสมุดแสตมป์อยู่แล้ว ไม่สามารถรับแสตมป์ซ้ำได้",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.redAccent,
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
      break;
    default:
      return showMessageBox(
        context,
        title: "เกิดข้อผิดพลาด",
        content: "เกิดข้อผิดพลาดไม่ทราบสาเหตุระหว่างการรับแสตมป์ (Code: " +
            json.decode(response.body)["inAppStatusCode"] +
            ")",
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
