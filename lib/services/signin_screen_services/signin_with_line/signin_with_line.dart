import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
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
import 'package:psm_at_stamp/services/signin_screen_services/signin_with_line/jwt_decode_service.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_with_line/signin_with_line_platformexception_handler.dart';

Future<void> signInWithLine(BuildContext context) async {
  showLoadingBox(context, loadingMessage: "กำลังเข้าสู่ระบบด้วย LINE");
  LoginResult _lineLoginResult;
  Map<String, dynamic> _idTokenDecode;
  try {
    _lineLoginResult =
        await LineSDK.instance.login(scopes: ["profile", "openid", "email"]);
    logger.d(json.encode(_lineLoginResult.data));
    if (Platform.isIOS) {
      _idTokenDecode =
          jwtDecode(token: _lineLoginResult.accessToken.data["id_token"]);
    } else if (Platform.isAndroid) {
      _idTokenDecode = jwtDecode(
          token: (jsonDecode(
              _lineLoginResult.accessToken.data["id_token"]))["rawString"]);
    } else {
      throw PlatformException(
          code: "PLATFORM_UNSUPPORTED",
          details:
              "Sign-in with LINE in PSM @ STAMP currently supported on iOS and Android");
    }
    if (_idTokenDecode["email"] == null) {
      throw PlatformException(code: "NO_EMAIL_IN_IDTOKEN");
    }
  } on PlatformException catch (e) {
    Navigator.pop(context);
    signInWithLinePlatformExceptionHandler(context, exception: e);
    return;
  } catch (e) {
    Navigator.pop(context);
    logger.d(e);
    showMessageBox(
      context,
      title: "เกิดข้อผิดพลาดไม่ทราบสาเหตุ",
      content:
          "เกิดข้อผิดพลาดระหว่างการเข้าสู่ระบบด้วย LINE กรุณาลองใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
    );
  }
  Map<String, dynamic> _reqBody = {
    "accessToken": _lineLoginResult.accessToken.data["access_token"],
    "displayName": _idTokenDecode["name"],
    "userId": _idTokenDecode["sub"],
    "profileImage": _idTokenDecode["picture"],
    "channelId": "1588292412",
    "email": _idTokenDecode["email"]
  };

  String _customToken = (await http.post(
    "https://asia-east2-satitprasarnmit-psm-at-stamp.cloudfunctions.net/SignInWithLine_FirebaseAuth",
    body: _reqBody,
  ))
      .body;
  logger.d(_customToken);
  AuthResult _authResult;
  try {
    _authResult =
        await FirebaseAuth.instance.signInWithCustomToken(token: _customToken);
  } on PlatformException catch (e) {
    Navigator.pop(context);
    signInPlatformExceptionHandler(context, e);
  } catch (e) {
    Navigator.pop(context);
    logger.d(e);
    showMessageBox(
      context,
      title: "เกิดข้อผิดพลาดไม่ทราบสาเหตุ",
      content:
          "เกิดข้อผิดพลาดระหว่างการเข้าสู่ระบบด้วย LINE กรุณาลองใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
    );
  }

  try {
    PsmAtStampUser psmAtStampUser = await signUserIn(
      userId: _authResult.user.uid,
      accessToken: _lineLoginResult.accessToken.data["access_token"],
      signInServices: SignInServices.line,
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
          displayName: _authResult.user.displayName ?? "Stamp User",
          userId: _authResult.user.uid,
          signInServices: SignInServices.line);
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
