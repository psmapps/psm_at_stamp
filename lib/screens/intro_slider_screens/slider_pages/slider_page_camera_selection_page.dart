import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/camera_selection_box_component/camera_selection_box.dart';
import 'package:psm_at_stamp/components/intro_slider_components/slider_component.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
import 'package:psm_at_stamp/screens/home_screens/home_screen.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

Widget sliderPageStampCameraSelectionPage(BuildContext context,
    {@required PsmAtStampUser psmAtStampUser}) {
  return sliderComponent(
    imageAsset: "assets/images/cameraSelect.gif",
    sliderWidget: Column(
      children: <Widget>[
        Text(
          "หากกล้องหลังไม่สามารถใช้งานได้ ?",
          style: TextStyle(
            color: Colors.orange,
            fontFamily: "Sukhumwit",
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
        Text(
          "ไม่เป็นไร! คุณสามารถเลือกใช้งานกล้องตัวอื่นแทนได้!",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Sukhumwit",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
        Text(
          "* คุณสามารถเปลี่ยนการตั้งค่านี้ได้ภายหลังที่หน้า ตั้งค่า *",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Sukhumwit",
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: CameraSelectionBox(),
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
