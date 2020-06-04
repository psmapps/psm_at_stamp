import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:http/http.dart' as http;
import 'package:psm_at_stamp/components/notification_components/loading_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

Future<void> manualDistributingService({
  BuildContext context,
  @required PsmAtStampUser psmAtStampUser,
  @required String studentId,
}) async {
  if (studentId.length != 6) {
    throw PlatformException(
      code: "BAD_STUDENTID",
      details: "กรุณากรอกรหัสนักเรียนให้ครบ 6 หลักก่อนกดเพิ่มแสตมป์",
    );
  }
  showLoadingBox(context, loadingMessage: "กำลังเพิ่มข้อมูล");
  String manualStampApi =
      "https://asia-east2-satitprasarnmit-psm-at-stamp.cloudfunctions.net/v4-manualAddStamp";
  var udid = await FlutterUdid.udid;
  http.Response response;
  try {
    response = await http.post(
      manualStampApi,
      headers: {
        "authorization": psmAtStampUser.accessToken,
      },
      body: {
        "userId": psmAtStampUser.userId,
        "udid": udid,
        "studentId": studentId,
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
  logger.d(responseBody);
  Navigator.popUntil(context, (route) => route.isFirst);
  if (response.statusCode == 200) {
    return true;
  } else {
    switch (responseBody["inAppStatusCode"]) {
      case "400-2":
        throw PlatformException(
          code: "STUDENTID_NOTFOUND",
          details:
              "ไม่พบรหัสนักเรียนนี้ หากนักเรียนยังไม่เคยเปิดบัญชี กรุณาแจ้งนักเรียนให้เปิดบัญชี PSM @ STAMP หรือลองใหม่อีกครั้ง",
        );
        break;
      case "400-3":
        throw PlatformException(
          code: "STAMP_TRANS_EXISTS",
          details:
              "รหัสนักเรียนนี้เคยใช้รับแสตมป์ของฐานกิจกรรมนี้ไปแล้ว ไม่สามารถเพิ่มซ้ำได้",
        );
        break;
      case "401-1":
        throw PlatformException(
          code: "BAD_CREDENTIAL",
          details:
              "เกิดข้อผิดพลาดระหว่างการสร้างแสตมป์ใหม่ กรุณาเข้าสู่ระบบใหม่และลองใหม่อีกครั้ง",
        );
        break;
      case "401-2":
        throw PlatformException(
          code: "NO_PERMISSION",
          details: "ไม่พบสิทธิการแจกแสตมป์ของคุณ",
        );
        break;
      default:
        throw PlatformException(
          code: responseBody["inAppStatusCode"],
          details:
              "เกิดข้อผิดพลาดระหว่างการสร้างแสตมป์ใหม่ กรุณาลองใหม่อีกครั้ง",
        );
    }
  }
}
