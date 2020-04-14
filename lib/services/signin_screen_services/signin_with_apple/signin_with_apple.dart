import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_component/loading_box.dart';
import 'package:psm_at_stamp/components/notification_component/message_box.dart';
import 'package:psm_at_stamp/screens/home_screen.dart';
import 'package:psm_at_stamp/screens/register_screen.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/sign_user_in.dart';

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
  if (_signInWithAppleResult.status == AuthorizationStatus.error ||
      _signInWithAppleResult.status == AuthorizationStatus.cancelled) {
    switch (_signInWithAppleResult.status) {
      case AuthorizationStatus.error:
        showMessageBox(context,
            title: "เกิดข้อผิดพลาด",
            content: _signInWithAppleResult.error.localizedDescription,
            icon: FontAwesomeIcons.exclamationCircle,
            iconColor: Colors.red);
        break;
      default:
        break;
    }
    Navigator.pop(context);
    return;
  }
  final AuthCredential _credential =
      OAuthProvider(providerId: "apple.com").getCredential(
    idToken:
        String.fromCharCodes(_signInWithAppleResult.credential.identityToken),
    accessToken: String.fromCharCodes(
        _signInWithAppleResult.credential.authorizationCode),
  );
  try {
    final AuthResult _result =
        await FirebaseAuth.instance.signInWithCredential(_credential);
    final String _udid = await FlutterUdid.udid;
    final PsmAtStampUser _psmAtStampUser = await signUserIn(
        userId: _result.user.uid,
        accessToken: String.fromCharCodes(
            _signInWithAppleResult.credential.authorizationCode),
        udid: _udid);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomeScreen(psmAtStampUser: _psmAtStampUser)),
    );
  } on PlatformException catch (e) {
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
  } catch (e) {
    Navigator.pop(context);
    logger.d(e);
    showMessageBox(
      context,
      title: "ไม่สามารถเข้าสู่ระบบได้",
      content:
          "เกิดข้อผิดพลาดไม่ทราบสาเหตุ ทำให้ไม่สามารถเข้าสู่ระบบด้วย Apple ได้ กรุณาลองใหม่อีกครั้ง",
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
    );
  }
}
