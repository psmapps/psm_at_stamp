import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/intro_slider_components/slider_component.dart';

Widget sliderPageStampHowToGetStampPage() {
  return sliderComponent(
    imageAsset: "assets/images/howtoGetStamp.gif",
    title: "วิธีการรับแสตมป์ 3 ขั้นตอน ง่ายๆ",
    titleColor: Colors.green[300],
    subTitle:
        "1. เข้าร่วมกิจกรรมที่ฐานกิจกรรม \n 2. กดสแกน QR Code จากพี่ประจำฐาน \n 3. รับแสตมป์เรียบร้อย!",
  );
}
