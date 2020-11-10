import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/loading_box.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_stamp_services/psmatstamp_stamp_data_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/register_services/psmatstampregister_constructure.dart';

/// registerConfirm is used to register user in database
/// * Required
/// [psmAtStampRegister]
/// * Optional
/// [psmAtStampStampData]
Future<void> registerConfirm(
  BuildContext context, {
  @required PsmAtStampRegister psmAtStampRegister,
  PsmAtStampStampData psmAtStampStampData,
}) async {
  showLoadingBox(context, loadingMessage: "กำลังผูกบัญชี");
  DocumentSnapshot docSnap;
  try {
    docSnap = await FirebaseFirestore.instance
        .collection("Student_Data")
        .doc(psmAtStampRegister.studentId)
        .get();
  } catch (e) {
    logger.d(e);
    Navigator.pop(context);
    return showMessageBox(
      context,
      title: "เกิดข้อผิดพลาดระหว่างการผูกบัญชี",
      content: "กรุณาลองผูกบัญชีใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
  if (docSnap.data()["isRegistered"] != null &&
      docSnap.data()["isRegistered"]) {
    Navigator.pop(context);
    return showMessageBox(
      context,
      title: "รหัสนักเรียนนี้ใช้ผูกบัญชีไปแล้ว",
      content:
          "รหัสนักเรียนนี้ใช้ผูกบัญชีไปแล้ว ไม่สามารถผูกได้อีกครั้ง กรุณากรอกรหัสนักเรียนใหม่หรือติดต่อ PSM @ STAMP Team",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
  await FirebaseFirestore.instance
      .collection("Student_Data")
      .doc(psmAtStampRegister.studentId)
      .update({"isRegistered": true});
  if (psmAtStampRegister.permission == PsmAtStampUserPermission.staff) {
    await FirebaseFirestore.instance
        .collection("Staff_Register_Request")
        .doc()
        .set({
      "stampId": psmAtStampStampData.stampId,
      "studentId": psmAtStampRegister.studentId,
      "userId": psmAtStampRegister.userId,
    });
  }

  try {
    await FirebaseFirestore.instance
        .collection("Stamp_User")
        .doc(psmAtStampRegister.userId)
        .set({
      "displayName": psmAtStampRegister.displayName,
      "accessToken": "",
      "prefix": psmAtStampRegister.prefix,
      "name": psmAtStampRegister.name,
      "surname": psmAtStampRegister.surname,
      "year": psmAtStampRegister.year,
      "room": psmAtStampRegister.room,
      "studentId": psmAtStampRegister.studentId,
      "userId": psmAtStampRegister.userId,
      "profileImage": psmAtStampRegister.profileImage,
      "permission": "Student",
      "registerService":
          EnumToString.convertToString(psmAtStampRegister.signInServices),
    });
  } catch (e) {
    logger.d(e);
    Navigator.pop(context);
    return showMessageBox(
      context,
      title: "เกิดข้อผิดพลาดระหว่างการผูกบัญชี",
      content: "กรุณาลองผูกบัญชีใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
  logger.d("Registered user " + psmAtStampRegister.userId + " in database.");
  String content = "คุณสามารถเข้าสู่ระบบอีกครั้งด้วย " +
      EnumToString.convertToString(psmAtStampRegister.signInServices) +
      " เพื่อเริ่มต้นใช้งานได้ทันที ";
  if (psmAtStampRegister.permission == PsmAtStampUserPermission.staff) {
    content +=
        " สำหรับผู้ดูแลฐานกิจกรรม จะรอการตรวจสอบความถูกต้องของบัญชีและคุณจะได้รับสิทธิในการจัดการฐานกิจกรรมของคุณหลังจากคุณได้รับการยืนยันแล้ว";
  }
  Navigator.pop(context);
  showMessageBox(
    context,
    title: "ผูกบัญชีเรียบร้อย",
    content: content,
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
