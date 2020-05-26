import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/loading_box.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

Future<void> registerStaffAddToRequest(
  BuildContext context, {
  @required PsmAtStampUser psmAtStampUser,
  @required String stampLinkCode,
}) async {
  if (stampLinkCode == "") {
    return showMessageBox(
      context,
      title: "รหัสฐานกิจกรรมไม่ถูกต้อง",
      content: "กรุณากรอกรหัสฐานกิจกรรมก่อนเริ่มลงทะเบียน",
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
    );
  }
  showLoadingBox(context, loadingMessage: "กำลังตรวจสอบสิทธิ");
  QuerySnapshot stampQuerySnap = await Firestore.instance
      .collection("Stamp_Data")
      .where("stampLinkCode", isEqualTo: stampLinkCode)
      .limit(1)
      .getDocuments();
  if (stampQuerySnap.documents.isEmpty) {
    Navigator.pop(context);
    return showMessageBox(
      context,
      title: "รหัสฐานกิจกรรมไม่ถูกต้อง",
      content:
          "ไม่พบรหัสฐานกิจกรรมตามที่คุณระบุมา กรุณาตรวจสอบความถูกต้องและลองใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
    );
  }
  String categories;
  String name;
  String stampId;
  stampQuerySnap.documents.forEach((stampDocSnap) {
    categories = stampDocSnap.data["categories"];
    name = stampDocSnap.data["name"];
    stampId = stampDocSnap.documentID;
  });

  if (categories == null || name == null) {
    Navigator.pop(context);
    return showMessageBox(
      context,
      title: "ข้อมูลแสตมป์บางส่วนไม่สมบูรณ์",
      content:
          "กรุณาแจ้ง PSM @ STAMP Team เพื่อดำเนินการแก้ไข ขออภัยในความไม่สะดวก (Code: CATEGORIES_NAME_NULL)",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
  QuerySnapshot regStaffRequest = await Firestore.instance
      .collection("Staff_Register_Request")
      .where("userId", isEqualTo: psmAtStampUser.userId)
      .getDocuments();
  if (regStaffRequest.documents.isNotEmpty) {
    Navigator.pop(context);
    return showMessageBox(
      context,
      title: "เกิดข้อผิดพลาด",
      content:
          "คุณขอสิทธิการเป็น Staff ไปแล้ว จึงไม่สามารถขอได้อีก กรุณารอการตรวจสอบจาก Administrator",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
  try {
    await Firestore.instance
        .collection("Staff_Register_Request")
        .document()
        .setData({
      "stampId": stampId,
      "studentId": psmAtStampUser.studentId,
      "userId": psmAtStampUser.userId,
    }).timeout(Duration(seconds: 10));
  } catch (e) {
    Navigator.pop(context);
    return showMessageBox(
      context,
      title: "เกิดข้อผิดพลาด",
      content: "ไม่สามารถบันทึกข้อมูลการลงทะเบียนได้ กรุณาลองใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
  Navigator.pop(context);
  return showMessageBox(
    context,
    title: "สำเร็จ",
    content:
        "การขอสิทธิการเป็น Staff สำเร็จ หลังจากนี้ กรุณารอการตอบรับจาก Admin เพื่อยืนยันตัวตนของคุณ หากได้รับสิทธิ Staff แล้ว คุณจะสามารถเข้าสู่ระบบแจก Stamp และจัดการฐานกิจกรรมได้อัตโนมัติ",
    icon: FontAwesomeIcons.infoCircle,
    iconColor: Colors.green,
    actionsButton: [
      IconButton(
        icon: Icon(FontAwesomeIcons.timesCircle),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      )
    ],
  );
}
