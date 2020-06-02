import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/intro_slider_components/slider_component.dart';
import 'package:psm_at_stamp/components/permission_box_component/permission_box_component.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
import 'package:psm_at_stamp/screens/home_screens/home_screen.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

Widget sliderPageStampPermissionPage(
  BuildContext context, {
  @required PsmAtStampUser psmAtStampUser,
}) {
  return sliderComponent(
    imageAsset: "assets/images/permission.gif",
    sliderWidget: Column(
      children: <Widget>[
        Text(
          "กรุณาอนุญาตสิทธิการเข้าถึงเหล่านี้ \n เพื่อใช้งาน PSM @ STAMP",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Sukhumwit",
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
          child: PermissionBox(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
          child: signInButtonComponent(
            icon: FontAwesomeIcons.signInAlt,
            title: "เข้าสู่แอพ PSM @ STAMP",
            onPressHandler: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    psmAtStampUser: psmAtStampUser,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
