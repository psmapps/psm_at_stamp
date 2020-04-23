import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_component/loading_box.dart';
import 'package:psm_at_stamp/components/notification_component/message_box.dart';
import 'package:psm_at_stamp/screens/home_screens/home_screen.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/sign_user_in.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/sign_user_in_error_handler.dart';
import 'package:psm_at_stamp/services/register_services/psmatstampregister_constructure.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_platformexception_handler.dart';

Future<void> signInWithApple(BuildContext context) async {
  if (!(await AppleSignIn.isAvailable())) {
    showMessageBox(context,
        title: "ไม่สามารถเข้าสู่ระบบด้วย Apple",
        content:
            "อุปกรณ์ของคุณไม่รองรับการเข้าสู่ระบบด้วย Apple กรุณาลองตัวเลือกการเข้าสู่ระบบอื่นๆ",
        icon: FontAwesomeIcons.exclamationTriangle,
        iconColor: Colors.yellow);
    return;
  }
  showLoadingBox(context, loadingMessage: "กำลังเข้าสู่ระบบด้วย Apple");
  final AuthorizationResult _signInWithAppleResult =
      await AppleSignIn.performRequests([
    AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  ]);
  if (_signInWithAppleResult.status == AuthorizationStatus.cancelled) {
    Navigator.pop(context);
    return;
  }
  if (_signInWithAppleResult.status == AuthorizationStatus.error) {
    Navigator.pop(context);
    return showMessageBox(context,
        title: "เกิดข้อผิดพลาด",
        content:
            "ไม่สามารถเข้าสู่ระบบด้วย Apple ได้ กรุณาตรวจสอบการเชื่อมต่อ หรือ ติดต่อ PSM @ STAMP เพื่อรับการช่วยเหลือ (Code: " +
                _signInWithAppleResult.error.code.toString() +
                ")",
        icon: FontAwesomeIcons.exclamationCircle,
        iconColor: Colors.red);
  }
  final AuthCredential _credential =
      OAuthProvider(providerId: "apple.com").getCredential(
    idToken:
        String.fromCharCodes(_signInWithAppleResult.credential.identityToken),
    accessToken: String.fromCharCodes(
        _signInWithAppleResult.credential.authorizationCode),
  );
  AuthResult _authResult;
  try {
    _authResult = await FirebaseAuth.instance
        .signInWithCredential(_credential)
        .timeout(Duration(seconds: 10));
  } on PlatformException catch (e) {
    Navigator.pop(context);
    signInPlatformExceptionHandler(context, e);
  } catch (e) {
    Navigator.pop(context);
    logger.d(e);
    showMessageBox(
      context,
      title: "ไม่สามารถเข้าสู่ระบบได้",
      content:
          "เกิดข้อผิดพลาดไม่ทราบสาเหตุ อาจเป็นเพราะการเชื่อมต่อไม่สำเร็จ ทำให้ไม่สามารถเข้าสู่ระบบด้วย Apple ได้ กรุณาลองใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
    );
  }
  logger.d(_authResult.user.uid);
  try {
    PsmAtStampUser psmAtStampUser = await signUserIn(
      userId: _authResult.user.uid,
      accessToken: String.fromCharCodes(
        _signInWithAppleResult.credential.authorizationCode,
      ),
      signInServices: SignInServices.apple,
    );
    Navigator.pop(context);
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
    if (e.code == "ACCOUNT_NOT_FOUND") {
      PsmAtStampRegister psmAtStampRegister = new PsmAtStampRegister(
        email: _authResult.user.email,
        profileImage: _authResult.user.photoUrl ??
            "https://firebasestorage.googleapis.com/v0/b/satitprasarnmit-psm-at-stamp.appspot.com/o/user.png?alt=media&token=eb023a2a-0d9e-46f2-8301-ef4e0e20cfee",
        displayName: "Stamp User",
        userId: _authResult.user.uid,
        signInServices: SignInServices.apple,
      );
      return signUserInErrorHandler(
        context,
        exception: e,
        psmAtStampRegister: psmAtStampRegister,
      );
    }
    return signUserInErrorHandler(
      context,
      exception: e,
    );
  }
}
