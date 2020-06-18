import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:psm_at_stamp/components/button_components/app_button_components.dart';
import 'package:psm_at_stamp/components/permission_box_component/permission_box_component.dart';
import 'package:psm_at_stamp/screens/intro_slider_screens/intro_slider_screens.dart';
import 'package:psm_at_stamp/screens/staff_screens/request_staff_privilege_screens/request_staff_privilege_screen.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

class SettingScreen extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  SettingScreen({
    Key key,
    @required this.psmAtStampUser,
  }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String buildNumber = "-";
  String version = "-";
  bool isShowStaffRegButton = false;

  @override
  void initState() {
    getPackageInfo();
    super.initState();
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      buildNumber = packageInfo.buildNumber;
      version = packageInfo.version;
    });
  }

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
              GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    isShowStaffRegButton = true;
                  });
                },
                child: Image.asset(
                  "assets/images/icons/icon_transparent.png",
                  scale: 5,
                ),
              ),
              Text(
                "PSM @ STAMP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Version " + version + " ( Build " + buildNumber + " )",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Develop by: Siratee K. (G.60)",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
              ),
              PermissionBox(),
              appButtonComponent(
                icon: FontAwesomeIcons.book,
                title: "เปิดหน้า Intro อีกครั้ง",
                buttonColor: Colors.white,
                onPressHandler: () {
                  Navigator.pop(context);
                  return Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntroSliderScreen(
                        psmAtStampUser: widget.psmAtStampUser,
                      ),
                    ),
                  );
                },
              ),
              widget.psmAtStampUser.permission ==
                      PsmAtStampUserPermission.student
                  ? isShowStaffRegButton
                      ? appButtonComponent(
                          icon: FontAwesomeIcons.userAlt,
                          title: "ขอสิทธ์การเป็น Staff ฐานกิจกรรม",
                          buttonColor: Colors.white,
                          onPressHandler: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RequestStaffPrivilegeScreen(
                                  psmAtStampUser: widget.psmAtStampUser,
                                ),
                              ),
                            );
                          },
                        )
                      : Container()
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
