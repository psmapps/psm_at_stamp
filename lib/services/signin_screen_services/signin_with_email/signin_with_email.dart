import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_component/loading_box.dart';
import 'package:psm_at_stamp/components/notification_component/message_box.dart';
import 'package:psm_at_stamp/screens/home_screen.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/sign_user_in.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_platformexception_handler.dart';

Future<void> signInWithEmail(BuildContext context,
    {@required String email, @required String password}) async {
  showLoadingBox(context,
      loadingMessage: "กำลังเข้าสู่ระบบด้วย Email/Password");
  try {
    AuthResult _result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    PsmAtStampUser psmAtStampUser = await signUserIn(
        userId: _result.user.uid, accessToken: "SIGNIN_WITH_EMAIL");
    logger.d(psmAtStampUser);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          psmAtStampUser: psmAtStampUser,
        ),
      ),
    );
  } on PlatformException catch (e) {
    Navigator.pop(context);
    signInPlatformExceptionHandler(context, e);
  } catch (e) {
    Navigator.pop(context);
    logger.d(e);
    showMessageBox(
      context,
      title: "เกิดข้อผิดพลาดไม่ทราบสาเหตุ",
      content: "เกิดข้อผิดพลาดโดยไม่ทราบสาเหตุ กรุณาลองใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
    );
  }
}
