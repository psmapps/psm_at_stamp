import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

Future<void> changeStampStatus(
  BuildContext context, {
  @required bool value,
  @required PsmAtStampUser psmAtStampUser,
}) async {
  try {
    await Firestore.instance
        .collection("Stamp_Data")
        .document(psmAtStampUser.stampId)
        .updateData({
      "isOpen": value,
    });
  } catch (e) {
    showMessageBox(
      context,
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
      title: "เกิดข้อผิดพลาด",
      content: "ไม่สามารถเปลี่ยนแปลงสถาณะฐานกิจกรรมได้ กรุณาลองใหม่อีกครั้ง",
    );
  }
}
