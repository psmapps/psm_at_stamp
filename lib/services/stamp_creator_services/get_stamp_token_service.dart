import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:http/http.dart' as http;

Future<String> getStampTokenService(BuildContext context,
    {@required PsmAtStampUser psmAtStampUser}) async {
  String createStampTokenApiUrl =
      "https://asia-east2-satitprasarnmit-psm-at-stamp.cloudfunctions.net/createStampToken/";
  var udid = await FlutterUdid.udid;
  http.Response response;
  try {
    response = await http.post(
      createStampTokenApiUrl,
      headers: {
        "authorization": psmAtStampUser.accessToken,
      },
      body: {
        "userId": psmAtStampUser.userId,
        "udid": udid,
        "stampId": psmAtStampUser.stampId,
      },
    ).timeout(Duration(seconds: 10));
  } catch (e) {
    logger.e(e);
    Navigator.popUntil(context, (route) => route.isFirst);
    throw PlatformException(
      code: "FETCH_FAILED",
      details:
          "ไม่สามารถติดต่อ PSM @ STAMP ได้ กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ตและลองใหม่อีกครั้ง",
    );
  }
  Map<String, dynamic> responseBody = json.decode(response.body);
  if (response.statusCode == 200) {
    return responseBody["token"];
  } else {
    switch (responseBody["inAppStatusCode"]) {
      case "401-1":
        throw PlatformException(
          code: "ERR_IN_REQUEST",
          details:
              "เกิดข้อผิดพลาดระหว่างการสร้างแสตมป์ใหม่ กรุณาเข้าสู่ระบบใหม่และลองใหม่อีกครั้ง",
        );
        break;
      case "401-2":
        throw PlatformException(
          code: "ERR_IN_REQUEST",
          details: "ไม่พบสิทธิการแจกแสตมป์ของคุณ",
        );
        break;
      default:
        throw PlatformException(
          code: "ERR_IN_REQUEST",
          details:
              "เกิดข้อผิดพลาดระหว่างการสร้างแสตมป์ใหม่ กรุณาลองใหม่อีกครั้ง",
        );
    }
  }
}
