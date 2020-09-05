import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psm_at_stamp/components/notification_components/loading_box.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/screens/signin_screens/signin_screen.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/delete_credential_file.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/listener_on_user_update.dart';

Future<void> signUserOut(
  BuildContext context, {
  @required PsmAtStampUser psmAtStampUser,
  bool failureAsk,
  bool updateCredentailInDatabase,
}) async {
  Navigator.popUntil(context, ((route) => route.isFirst));
  showLoadingBox(context, loadingMessage: "กำลังออกจากระบบ");
  onUserUpdateStreamSubscription.cancel();
  if (updateCredentailInDatabase ?? true) {
    try {
      await FirebaseFirestore.instance
          .collection("Stamp_User")
          .doc(psmAtStampUser.userId)
          .update({
        "udid": "",
        "accessToken": "",
        "fcmToken": "",
        "isFourceSignOut": false,
        "signInService": null,
      }).timeout(Duration(seconds: 10));
      if (psmAtStampUser.signInServices == SignInServices.google) {
        await GoogleSignIn().signOut();
      }
      if (psmAtStampUser.signInServices == SignInServices.line) {
        await LineSDK.instance.logout();
      }
      await FirebaseAuth.instance.signOut().timeout(Duration(seconds: 10));
    } catch (e) {
      Navigator.pop(context);
      logger.d(e);
      if (failureAsk == null || failureAsk == true) {
        return showMessageBox(
          context,
          title: "ออกจากระบบไม่สำเร็จ",
          content:
              "เกิดข้อผิดพลาดบางอย่างทำให้การลงชื่อออกจากระบบกับ PSM @ STAMP ไม่สำเร็จ อย่างไรก็ตาม คุณยังคงต้องการออกจากระบบอยู่หรือไม่ ? หากออกจากระบบตอนนี้ คุณอาจได้รับข้อความเตือนเรื่องการเข้าสู่ระบบซ้ำในการเข้าสู่ระบบครั้งถัดไป",
          icon: FontAwesomeIcons.exclamationTriangle,
          iconColor: Colors.yellow,
          actionsButton: [
            IconButton(
              icon: Icon(FontAwesomeIcons.timesCircle),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.checkCircle),
              color: Colors.redAccent,
              onPressed: () {
                Navigator.pop(context);
                signUserOut(
                  context,
                  psmAtStampUser: psmAtStampUser,
                  failureAsk: false,
                );
              },
            ),
          ],
        );
      }
    }
  }
  await deleteCredentialFile();
  logger.d("Signed out user " + psmAtStampUser.userId);
  Navigator.pop(context);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => SignInScreen()),
  );
}
