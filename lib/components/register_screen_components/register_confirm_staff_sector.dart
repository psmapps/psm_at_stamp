import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/register_screen_components/register_stamp_info_component.dart';
import 'package:psm_at_stamp/services/psmatstamp_stamp_services/psmatstamp_stamp_data_constructure.dart';

Widget registerConfirmStaffSector(
    {@required PsmAtStampStampData psmAtStampStampData}) {
  return Container(
    padding: const EdgeInsets.all(20),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ListTile(
            title: Row(
              children: <Widget>[
                FaIcon(FontAwesomeIcons.solidBookmark),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                ),
                Text(
                  "ฐานกิจกรรมที่ดูแล",
                  style: TextStyle(
                    fontFamily: "Sukhumwit",
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                registerStampInfo(
                  index: "ชื่อ:",
                  data: psmAtStampStampData.name,
                ),
                registerStampInfo(
                  index: "กลุ่มสาระ:",
                  data: psmAtStampStampData.categories,
                ),
                registerStampInfo(
                  index: "ที่ตั้งฐานกิจกรรม:",
                  data: psmAtStampStampData.location,
                ),
                registerStampInfo(
                  index: "คำอธิบาย:",
                  data: psmAtStampStampData.detail,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "หากข้อมูลไม่ถูกต้อง คุณสามารถแก้ไขได้ด้วยตนเองหลังจากผูกบัญชีและได้รับการยืนยันการดูแลฐานกิจกรรมเรียบร้อยแล้ว (ข้อมูลที่แก้ไขได้: ชื่อ, คำอธิบาย, สถาณะฐานกิจกรรม, ที่ตั้งฐานกิจกรรม, Icon ฐานกิจกรรม)",
              style: TextStyle(
                fontFamily: "Sukhumwit",
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    ),
  );
}
