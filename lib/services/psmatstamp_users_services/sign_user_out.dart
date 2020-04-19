import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psm_at_stamp/components/notification_component/loading_box.dart';
import 'package:psm_at_stamp/screens/signin_screens/signin_screen.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/delete_credential_file.dart';

Future<void> signUserOut(BuildContext context,
    {@required PsmAtStampUser psmAtStampUser}) async {
  showLoadingBox(context, loadingMessage: "กำลังออกจากระบบ");
  try {
    await Firestore.instance
        .collection("Stamp_User")
        .document(psmAtStampUser.userId)
        .updateData({"udid": "", "accessToken": ""});
    await GoogleSignIn().signOut();
    await LineSDK.instance.logout();
    await FirebaseAuth.instance.signOut();
    await deleteCredentialFile();
  } catch (e) {
    logger.d(e);
    return;
  }
  Navigator.pop(context);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => SignInScreen()),
  );
}
