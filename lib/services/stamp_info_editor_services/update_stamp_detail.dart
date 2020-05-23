import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

Future<void> updateStampDetail(
  BuildContext context, {
  @required String setting,
  @required String value,
  @required PsmAtStampUser psmAtStampUser,
}) async {
  try {
    await Firestore.instance
        .collection("Stamp_Data")
        .document(psmAtStampUser.stampId)
        .updateData({setting: value});
  } catch (e) {
    logger.e(e);
    showMessageBox(
      context,
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
      title: "เกิดข้อผิดพลาด",
      content:
          "ไม่สามารถแก้ไขการตั้งค่าฐานกิจกรรมได้เนื่องจากเกิดข้อผิดพลาดบางอย่าง กรุณาลองใหม่อีกครั้ง",
    );
    throw null;
  }
  showMessageBox(
    context,
    icon: FontAwesomeIcons.check,
    iconColor: Colors.green,
    title: "สำเร็จ",
    content: "แก้ไขการตั้งค่าฐานกิจกรรมเรียบร้อยแล้ว",
  );
  return;
}
