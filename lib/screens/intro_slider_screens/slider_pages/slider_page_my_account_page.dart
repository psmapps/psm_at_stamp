import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/intro_slider_components/slider_component.dart';

Widget sliderPageStampMyAccountPage() {
  return sliderComponent(
    imageAsset: "assets/images/animation/stampAccountProfile.gif",
    title: "บัญชีของคุณ",
    titleColor: Colors.pink,
    subTitle:
        "หน้านี้จะบอกข้อมูลต่างๆเกี่ยวกับคุณทั้งหมด รวมถึงจำนวนแสตมป์ทั้งหมดที่คุณได้รับด้วย!",
  );
}
