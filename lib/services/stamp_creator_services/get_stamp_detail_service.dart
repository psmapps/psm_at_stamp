import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

Future<Map<String, dynamic>> getStampDetailService(BuildContext context,
    {@required PsmAtStampUser psmAtStampUser}) async {
  DocumentSnapshot stampDoc;
  try {
    stampDoc = await Firestore.instance
        .collection("Stamp_Data")
        .document(psmAtStampUser.stampId)
        .get()
        .timeout(
          Duration(seconds: 10),
        );
  } catch (e) {
    logger.e(e);
    throw PlatformException(
        code: "get_stamp_data_failed",
        details: "ไม่สามารถติดต่อ PSM @ STAMP ได้ กรุณาลองใหม่อีกครั้ง");
  }
  if (!stampDoc.exists) {
    throw PlatformException(code: "stamp_not_found");
  }
  DocumentSnapshot permissionDoc;
  try {
    permissionDoc = await Firestore.instance
        .collection("Stamp_Data")
        .document(psmAtStampUser.stampId)
        .collection("staff")
        .document(psmAtStampUser.userId)
        .get();
  } catch (e) {
    logger.e(e);
    throw PlatformException(
        code: "Can't get permission",
        details: "ไม่สามารถตรวจสอบสิทธิการแจกแสตมป์ได้ กรุณาลองใหม่อีกครั้ง");
  }
  if (!permissionDoc.exists) {
    throw PlatformException(
        code: "Permission not found", details: "ไม่พบสิทธิการแจกแสตมป์ของคุณ");
  }

  if (stampDoc.data["iconUrl"] == "" || stampDoc.data["iconUrl"] == null) {
    DocumentSnapshot categoriesDoc;
    try {
      categoriesDoc = await Firestore.instance
          .collection("Categories")
          .document(stampDoc.data["categories"])
          .get()
          .timeout(Duration(seconds: 10));
    } catch (e) {
      return {
        "stampName": stampDoc.data["name"],
        "stampCategories": stampDoc.data["categories"],
        "iconUrl": null,
      };
    }
    if (categoriesDoc.exists) {
      if (categoriesDoc.data["iconUrl"] == null ||
          categoriesDoc.data["iconUrl"] == "") {
        return {
          "stampName": stampDoc.data["name"],
          "stampCategories": stampDoc.data["categories"],
          "iconUrl": null,
        };
      } else {
        return {
          "stampName": stampDoc.data["name"],
          "stampCategories": stampDoc.data["categories"],
          "iconUrl": categoriesDoc.data["iconUrl"],
        };
      }
    } else {
      return {
        "stampName": stampDoc.data["name"],
        "stampCategories": stampDoc.data["categories"],
        "iconUrl": null,
      };
    }
  } else {
    return {
      "stampName": stampDoc.data["name"],
      "stampCategories": stampDoc.data["categories"],
      "iconUrl": stampDoc.data["iconUrl"],
    };
  }
}
