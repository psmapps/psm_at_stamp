import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psm_at_stamp/components/notification_component/loading_box.dart';
import 'package:psm_at_stamp/components/notification_component/message_box.dart';
import 'package:psm_at_stamp/screens/home_screen.dart';
import 'package:psm_at_stamp/screens/register_screen.dart';
import 'package:psm_at_stamp/services/firebase_auth_services/signin_with_credential.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/sign_user_in.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_with_google/signin_with_google_services.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  showLoadingBox(context, loadingMessage: "กำลังเข้าสู่ระบบด้วย Google");
  try {
    final GoogleSignInAuthentication _googleSignInAuth =
        await startSignInWithGoogle();
    final AuthCredential _authCredential = GoogleAuthProvider.getCredential(
        idToken: _googleSignInAuth.idToken,
        accessToken: _googleSignInAuth.accessToken);
    final AuthResult _authResult =
        await firebaseAuthSignInWithCredential(credential: _authCredential);
    final String _udid = await FlutterUdid.udid;
    final PsmAtStampUser _psmatstampUser = await signUserIn(
        userId: _authResult.user.uid,
        accessToken: _googleSignInAuth.accessToken,
        udid: _udid);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  psmAtStampUser: _psmatstampUser,
                )));
  } on PlatformException catch (e) {
    GoogleSignIn().signOut();
    Navigator.pop(context);
    logger.d(e);
    switch (e.code) {
      case "ACCOUNT_DATA_INVALID":
        showMessageBox(context,
            title: "ไม่สามารถเข้าสู่ระบบได้",
            content:
                "บัญชีของคุณมีข้อผิดพลาดบางส่วน กรุณาติดต่อ PSM @ STAMP Team และแจ้งรหัสนักเรียนของคุณพร้อมกับ ERR_CODE นี้ เพื่อดำเนินการแก้ไขต่อไป (ERR_CODE: ACCOUNT_DATA_INVALID)",
            icon: FontAwesomeIcons.exclamationTriangle,
            iconColor: Colors.yellow);
        break;
      case "UNKNOWN_PERMISSION":
        showMessageBox(context,
            title: "ไม่สามารถเข้าสู่ระบบได้",
            content:
                "บัญชีของคุณมีข้อผิดพลาดบางส่วน กรุณาติดต่อ PSM @ STAMP Team และแจ้งรหัสนักเรียนของคุณพร้อมกับ ERR_CODE นี้ เพื่อดำเนินการแก้ไขต่อไป (ERR_CODE: UNKNOWN_PERMISSION)",
            icon: FontAwesomeIcons.exclamationTriangle,
            iconColor: Colors.yellow);
        break;
      case "ACCOUNT_NOT_FOUND":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
        showMessageBox(
          context,
          title: "ยินดีต้อนรับเข้าสู่ PSM @ STAMP",
          content:
              "กรุณาผูกบัญชีกับรหัสนักเรียนของคุณ การผูกบัญชีจะทำแค่ครั้งแรกเพียงครั้งเดียว",
          icon: FontAwesomeIcons.exclamationCircle,
          iconColor: Colors.greenAccent,
        );
        break;
      default:
        showMessageBox(context,
            title: e.code,
            content: e.details ?? "No data",
            icon: FontAwesomeIcons.exclamationCircle,
            iconColor: Colors.red);
        break;
    }
  } on NoSuchMethodError catch (e) {
    GoogleSignIn().signOut();
    Navigator.pop(context);
    logger.d(e);
  } catch (e) {
    GoogleSignIn().signOut();
    Navigator.pop(context);
    logger.d(e);
    showMessageBox(
      context,
      title: "ไม่สามารถเข้าสู่ระบบได้",
      content:
          "เกิดข้อผิดพลาดไม่ทราบสาเหตุ ทำให้ไม่สามารถเข้าสู่ระบบด้วย Google ได้ กรุณาลองใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
    );
  }
}
