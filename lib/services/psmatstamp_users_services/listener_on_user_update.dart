import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/sign_user_out.dart';

StreamSubscription onUserUpdateStreamSubscription;

void listenerOnUserUpdate(BuildContext context,
    {@required PsmAtStampUser psmAtStampUser}) async {
  logger.d("onUserUpdate: listener started");
  onUserUpdateStreamSubscription = Firestore.instance
      .collection("Stamp_User")
      .document(psmAtStampUser.userId)
      .snapshots()
      .listen((docSnap) async {
    logger.d("onUserUpdate: Update triggered");
    if (docSnap.data["udid"] != (await FlutterUdid.udid)) {
      logger.d(
          "onUserUpdate: Different user credential detected, Signing user out");
      return showMessageBox(
        context,
        title: "มีการเข้าสู่ระบบจากที่อื่น",
        content:
            "บัญชีของคุณมีการเข้าสู่ระบบจากอุปกรณ์เครื่องอื่น. 1 บัญชี PSM @ STAMP สามารถเข้าสู่ระบบได้บนอุปกรณ์เครื่องเดียวเท่านั้น. คุณจะถูกบังคับให้ออกจากระบบอัตโนมัติ",
        icon: FontAwesomeIcons.exclamationTriangle,
        iconColor: Colors.yellow,
        actionsButton: [
          IconButton(
            icon: Icon(FontAwesomeIcons.timesCircle),
            onPressed: () {
              Navigator.popUntil(context, ((route) => route.isFirst));
              signUserOut(
                context,
                psmAtStampUser: psmAtStampUser,
                updateCredentailInDatabase: false,
              );
            },
          )
        ],
      );
    }
    if (docSnap.data["isFourceSignOut"] ?? false == true) {
      logger.d("onUserUpdate: isFourceSignOut is triggered, Signing User Out");
      return showMessageBox(
        context,
        title: "คุณถูกบังคับให้ออกจากระบบ",
        content:
            "คุณถูกบังคับให้ออกจากระบบโดย Administrator. ระบบจะดำเนินการออกจากระบบอัตโนมัติ",
        icon: FontAwesomeIcons.exclamationTriangle,
        iconColor: Colors.yellow,
        actionsButton: [
          IconButton(
            icon: Icon(FontAwesomeIcons.timesCircle),
            onPressed: () {
              Navigator.popUntil(context, ((route) => route.isFirst));
              signUserOut(
                context,
                psmAtStampUser: psmAtStampUser,
                updateCredentailInDatabase: true,
              );
            },
          )
        ],
      );
    }
  });
}
