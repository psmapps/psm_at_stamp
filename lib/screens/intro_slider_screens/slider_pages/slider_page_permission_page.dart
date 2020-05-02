import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/intro_slider_components/slider_component.dart';
import 'package:psm_at_stamp/components/permission_box_component/permission_box_component.dart';

Widget sliderPageStampPermissionPage() {
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
      ],
    ),
  );
}
