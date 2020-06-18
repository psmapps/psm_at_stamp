import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

Widget badgeDisplayComponent({
  PsmAtStampUserPermission psmAtStampUserPermission,
  SignInServices signInServices,
}) {
  if (psmAtStampUserPermission != null) {
    switch (psmAtStampUserPermission) {
      case PsmAtStampUserPermission.administrator:
        return _badgeDisplayTemplate(
          toolTipMessage:
              "บัญชีนี้ได้รับการยืนยันจาก PSM @ STAMP ให้เป็น Administrator แล้ว",
          icon: Icons.verified_user,
          iconColor: Colors.blue,
        );
        break;
      case PsmAtStampUserPermission.staff:
        return _badgeDisplayTemplate(
          toolTipMessage:
              "บัญชีนี้ได้รับการยืนยันจาก PSM @ STAMP ให้เป็น Staff ฐานกิจกรรมแล้ว",
          icon: Icons.stars,
          iconColor: Colors.yellow[600],
        );
        break;
      default:
        return Container();
    }
  } else if (signInServices != null) {
    switch (signInServices) {
      case SignInServices.apple:
        return _badgeDisplayTemplate(
          toolTipMessage: "บัญชีนี้เข้าสู่ระบบด้วย Apple",
          icon: FontAwesomeIcons.apple,
        );
        break;
      case SignInServices.email:
        return _badgeDisplayTemplate(
          toolTipMessage: "บัญชีนี้เข้าสู่ระบบด้วย Email",
          icon: Icons.email,
        );
        break;
      case SignInServices.line:
        return _badgeDisplayTemplate(
          toolTipMessage: "บัญชีนี้เข้าสู่ระบบด้วย LINE",
          icon: FontAwesomeIcons.line,
          iconColor: Colors.green,
        );
        break;
      case SignInServices.google:
        return _badgeDisplayTemplate(
          toolTipMessage: "บัญชีนี้เข้าสู่ระบบด้วย Google",
          icon: FontAwesomeIcons.google,
        );
        break;
      default:
        return Container();
    }
  } else {
    return Container();
  }
}

Widget _badgeDisplayTemplate({
  @required String toolTipMessage,
  @required IconData icon,
  Color iconColor,
}) {
  return Tooltip(
    message: toolTipMessage,
    textStyle: TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    child: Icon(
      icon,
      color: iconColor ?? Colors.black,
    ),
  );
}
