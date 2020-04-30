import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/permission_box_component/permission_box_component.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
import 'package:psm_at_stamp/screens/intro_slider_screens/intro_slider_screens.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(90, 90, 90, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(31, 31, 31, 1),
        title: Row(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.cog,
              size: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
            ),
            Text(
              "ตั้งค่า",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Sukhumwit",
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Image.asset(
                "assets/images/icons/icon_transparent.png",
                scale: 5,
              ),
              Text(
                "PSM @ STAMP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Sukhumwit",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Version 3.1",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Sukhumwit",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Develop by: Siratee K. (G.60)",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Sukhumwit",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
              ),
              PermissionBox(),
              signInButtonComponent(
                icon: FontAwesomeIcons.book,
                title: "เปิดหน้า Intro อีกครั้ง",
                buttonColor: Colors.white,
                onPressHandler: () {
                  return Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntroSliderScreen(),
                    ),
                  );
                },
              ),
              signInButtonComponent(
                icon: FontAwesomeIcons.userAlt,
                title: "ขอสิทธ์การเป็น Staff ฐานกิจกรรม",
                buttonColor: Colors.white,
                onPressHandler: () {
                  return Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntroSliderScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
