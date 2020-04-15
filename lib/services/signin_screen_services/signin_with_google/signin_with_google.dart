import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psm_at_stamp/components/notification_component/loading_box.dart';
import 'package:psm_at_stamp/components/notification_component/message_box.dart';
import 'package:psm_at_stamp/screens/home_screen.dart';
import 'package:psm_at_stamp/services/firebase_auth_services/signin_with_credential.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/sign_user_in.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_platformexception_handler.dart';
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
    final PsmAtStampUser _psmatstampUser = await signUserIn(
      userId: _authResult.user.uid,
      accessToken: _googleSignInAuth.accessToken,
    );
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
    signInPlatformExceptionHandler(context, e);
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
