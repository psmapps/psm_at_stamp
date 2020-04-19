import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_component/message_box.dart';
import 'package:psm_at_stamp/screens/home_screens/home_screen.dart';
import 'package:psm_at_stamp/screens/signin_screens/signin_screen.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/delete_credential_file.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/read_credential_from_file.dart';

Future<void> welcomeCredentialCheck(BuildContext context) async {
  PsmAtStampUser psmAtStampUserFromCredentail;
  String _udid;
  DocumentSnapshot docSnap;
  try {
    psmAtStampUserFromCredentail = await readCredentailFromFile();
    _udid = await FlutterUdid.udid;
    docSnap = await Firestore.instance
        .collection("Stamp_User")
        .document(psmAtStampUserFromCredentail.userId)
        .get();
  } catch (e) {
    logger.d(e);
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  if (docSnap.data["accessToken"] != psmAtStampUserFromCredentail.accessToken &&
      docSnap.data["udid"] != _udid) {
    await deleteCredentialFile();
    return showMessageBox(
      context,
      title: "มีการเข้าสู่ระบบซ้ำ",
      content:
          "บัญชีของคุณมีการถูกเข้าสู่ระบบจากอุปกรณ์อื่น ผู้ใช้งานสามารถเข้าสู่ระบบได้บนอุปกรณ์เพียงอุปกรณ์เดียวเท่านั้น คุณจะถูกบังคับให้ออกจากระบบบนอุปกรณ์เครื่องนี้อัตโนมัติ",
      icon: FontAwesomeIcons.exclamationTriangle,
      iconColor: Colors.yellow,
      actionsButton: [
        IconButton(
          icon: Icon(FontAwesomeIcons.timesCircle),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
        )
      ],
    );
  }
  PsmAtStampUser psmAtStampUser = PsmAtStampUser(
    prefix: psmAtStampUserFromCredentail.prefix,
    name: psmAtStampUserFromCredentail.name,
    surname: psmAtStampUserFromCredentail.surname,
    userId: psmAtStampUserFromCredentail.userId,
    studentId: psmAtStampUserFromCredentail.studentId,
    year: psmAtStampUserFromCredentail.year,
    room: psmAtStampUserFromCredentail.room,
    permission: psmAtStampUserFromCredentail.permission,
    accessToken: psmAtStampUserFromCredentail.accessToken,
    udid: _udid,
    displayName: psmAtStampUserFromCredentail.displayName,
    profileImageUrl: psmAtStampUserFromCredentail.profileImageUrl,
    otherInfos: {"didOverrideSignIn": false},
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => HomeScreen(
        psmAtStampUser: psmAtStampUser,
      ),
    ),
  );
}
