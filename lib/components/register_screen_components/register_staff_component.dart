import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_component/message_box.dart';

Widget registerStaffSector(BuildContext context,
    {@required TextEditingController textEditingController}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
    child: Column(
      children: <Widget>[
        Text(
          "กรุณากรอกรหัสฐานกิจกรรมที่คุณได้รับมอบหมายให้ดูแล",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontFamily: "Sukhumwit",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        TextField(
          autocorrect: false,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Sukhumwit",
            fontSize: 20,
          ),
          controller: textEditingController,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              suffixIcon: IconButton(
                icon: FaIcon(FontAwesomeIcons.infoCircle),
                onPressed: () {
                  showMessageBox(
                    context,
                    title: "รหัสฐานกิจกรรม",
                    content:
                        "รหัสฐานกิจกรรมสามารถรับได้จากทีม PSM @ STAMP หรือ ประกาศจากฝ่ายวิชาการหรืออาจารย์ประจำหวดที่ดูแลกลุ่มสาระของฐานกิจกรรมนั้นๆ",
                    icon: FontAwesomeIcons.infoCircle,
                    iconColor: Colors.green,
                  );
                },
              )),
        )
      ],
    ),
  );
}
