import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/intro_slider_components/slider_component.dart';

Widget sliderPageStampIndicatorPage() {
  return sliderComponent(
    imageAsset: "assets/images/animation/stampindicator.gif",
    title: "Stamp Indicator",
    titleColor: Colors.lightBlue,
    subTitle:
        "ตัวช่วยบอกจำนวนแสตมป์ที่คุณได้รับจากกลุ่มสาระนั้นๆ โดยที่ไม่ต้องกดเข้าไปนับเองในกลุ่มสาระอีกแล้ว! \n (จำนวนแสตมป์ที่คุณได้รับ / จำนวนแสตมป์ทั้งหมด)",
  );
}
