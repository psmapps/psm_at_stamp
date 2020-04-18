import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_component/loading_box.dart';
import 'package:psm_at_stamp/components/notification_component/message_box.dart';
import 'package:psm_at_stamp/screens/register_screens/register_confirm_screen.dart';
import 'package:psm_at_stamp/services/psmatstamp_stamp_services/psmatstamp_stamp_data_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/register_services/psmatstampregister_constructure.dart';

Future<void> registerValidate(BuildContext context,
    {@required String studentId,
    @required PsmAtStampRegister psmAtStampRegister,
    String stampLinkCode}) async {
  if (studentId.length < 6) {
    return showMessageBox(
      context,
      title: "กรุณากรอกรหัสนักเรียนหรือรหัสบัญชีให้ครบ",
      content:
          "คุณกรอกรหัสนักเรียนหรอรหัสบัญชีไม่ครบ (ต้องมี 6 หลัก) กรุณากรอกให้ครบและลองใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
  if (psmAtStampRegister.permission == PsmAtStampUserPermission.staff &&
      stampLinkCode == "") {
    return showMessageBox(
      context,
      title: "กรุณากรอกรหัสฐานกิจกรรม",
      content:
          "การผูกบัญชีกับฐานกิจกรรม จะต้องใช้รหัสฐานกิจกรรมที่คุณดูแลอยู่ กรุณากรอกข้อมูลให้ถูกต้อง และลองใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
  showLoadingBox(context, loadingMessage: "กำลังตรวจสอบข้อมูล");
  DocumentSnapshot docSnap = await Firestore.instance
      .collection("Student_Data")
      .document(studentId)
      .get();

  if (!docSnap.exists) {
    Navigator.pop(context);
    return showMessageBox(
      context,
      title: "ไม่พบรหัสนักเรียนหรือรหัสบัญชีนี้",
      content: "ไม่พบรหัสนักเรียนหรือรหัสบัญชีที่คุณระบุมา ( " +
          studentId +
          " ) กรุณาตรวจสอบความถูกต้องและลองใหม่อีกครั้ง ",
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
    );
  }
  if (docSnap.data["isRegistered"] == true) {
    Navigator.pop(context);
    return showMessageBox(
      context,
      title: "รหัสนักเรียนหรือรหัสบัญชีนี้เคยใช้ผูกบัญชีไปแล้ว",
      content:
          "1 รหัสนักเรียน หรือ รหัสบัญชี จะสามารถใช้ผูกบัญชีได้เพียง 1 ครั้ง คุณอาจผูกบัญชีนี้กับการเข้าสู่ระบบอื่นๆ กรุณาลองเข้าสู่ระบบด้วยตัวเลือกอื่น หรือ ตรวจสอบความถูกต้องของข้อมูลอีกครั้ง หากคิดว่านี่เป็นข้อผิดพลาด กรุณาติดต่อ PSM @ STAMP Team",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
  if (docSnap.data["prefix"] == null ||
      docSnap.data["name"] == null ||
      docSnap.data["surname"] == null ||
      docSnap.data["year"] == null ||
      docSnap.data["room"] == null) {
    Navigator.pop(context);
    return showMessageBox(
      context,
      title: "ข้อมูลบัญชีของคุณบางส่วนไม่สมบูรณ์",
      content:
          "กรุณาติดต่อ PSM @ STAMP Team เพื่อดำเนินการแก้ไขข้อมูล ขออภัยในความไม่สะดวก",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
    );
  }
  PsmAtStampRegister psmAtStampRegisterMergeData = PsmAtStampRegister(
    userId: psmAtStampRegister.userId,
    displayName: psmAtStampRegister.displayName,
    profileImage: psmAtStampRegister.profileImage,
    email: psmAtStampRegister.email,
    signInServices: psmAtStampRegister.signInServices,
    permission: psmAtStampRegister.permission,
    prefix: docSnap.data["prefix"],
    name: docSnap.data["name"],
    surname: docSnap.data["surname"],
    year: docSnap.data["year"],
    room: docSnap.data["room"],
    studentId: studentId,
  );

  if (psmAtStampRegister.permission == PsmAtStampUserPermission.staff) {
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
    PsmAtStampStampData psmAtStampStampData;
    stampQuerySnap.documents.forEach((stampDocSnap) {
      if (stampDocSnap.data["categories"] == null ||
          stampDocSnap.data["name"] == null) {
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
      psmAtStampStampData = PsmAtStampStampData(
        stampId: stampDocSnap.documentID,
        categories: stampDocSnap.data["categories"],
        detail: stampDocSnap.data["detail"] ?? "ไม่มีข้อมูล",
        location: stampDocSnap.data["location"] ?? "ไม่มีข้อมูล",
        name: stampDocSnap.data["name"],
      );
    });
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterConfirmScreen(
          psmAtStampRegister: psmAtStampRegisterMergeData,
          psmAtStampStampData: psmAtStampStampData,
        ),
      ),
    );
  } else {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterConfirmScreen(
          psmAtStampRegister: psmAtStampRegisterMergeData,
        ),
      ),
    );
  }
}
