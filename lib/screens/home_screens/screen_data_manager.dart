import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/screens/home_screens/screen_widget_constructure.dart';
import 'package:psm_at_stamp/screens/my_account_screens/my_account_screen.dart';
import 'package:psm_at_stamp/screens/stamp_book_screens/stamp_book_screen.dart';
import 'package:psm_at_stamp/screens/stamp_creator_screens/stamp_creator_screen.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

ScreenWidget screenDataManager({@required PsmAtStampUser psmAtStampUser}) {
  switch (psmAtStampUser.permission) {
    case PsmAtStampUserPermission.student:
      return ScreenWidget(
        screenList: [
          StampBookScreen(
            psmAtStampUser: psmAtStampUser,
          ),
          MyAccountScreen(
            psmAtStampUser: psmAtStampUser,
          )
        ],
        tabBarList: [
          Tab(
            icon: Icon(FontAwesomeIcons.book),
            child: Text("สมุดแสตมป์"),
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.userAlt),
            child: Text("บัญชีของฉัน"),
          ),
        ],
        tabBarCount: 2,
      );
      break;
    case PsmAtStampUserPermission.staff:
      return ScreenWidget(
        screenList: [
          MyAccountScreen(
            psmAtStampUser: psmAtStampUser,
          ),
          StampCreatorScreen(
            psmAtStampUser: psmAtStampUser,
          ),
          MyAccountScreen(
            psmAtStampUser: psmAtStampUser,
          ),
          MyAccountScreen(
            psmAtStampUser: psmAtStampUser,
          ),
        ],
        tabBarList: [
          Tab(
            icon: Icon(FontAwesomeIcons.calendarDay),
            child: Text(
              "ฐานกิจกรรม",
              style: TextStyle(
                fontFamily: "Sukhumwit",
                fontSize: 13,
              ),
            ),
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.qrcode),
            child: Text(
              "แจกแสตมป์",
              style: TextStyle(
                fontFamily: "Sukhumwit",
                fontSize: 13,
              ),
            ),
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.pencilRuler),
            child: Text(
              "กรอกรหัสนักเรียน",
              style: TextStyle(
                fontFamily: "Sukhumwit",
                fontSize: 10,
              ),
            ),
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.userAlt),
            child: Text(
              "บัญชีของฉัน",
              style: TextStyle(
                fontFamily: "Sukhumwit",
                fontSize: 13,
              ),
            ),
          ),
        ],
        tabBarCount: 4,
      );

      break;
    case PsmAtStampUserPermission.administrator:
      return ScreenWidget(
        screenList: [
          MyAccountScreen(
            psmAtStampUser: psmAtStampUser,
          ),
          MyAccountScreen(
            psmAtStampUser: psmAtStampUser,
          )
        ],
        tabBarList: [
          Tab(
            icon: Icon(FontAwesomeIcons.calendarDay),
            child: Text("ฐานกิจกรรม"),
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.userAlt),
            child: Text("บัญชีของฉัน"),
          ),
        ],
        tabBarCount: 2,
      );
      break;
    default:
      return ScreenWidget(
        screenList: [
          MyAccountScreen(
            psmAtStampUser: psmAtStampUser,
          )
        ],
        tabBarList: [
          Tab(
            icon: Icon(FontAwesomeIcons.userAlt),
            child: Text("บัญชีของฉัน"),
          ),
        ],
        tabBarCount: 1,
      );
  }
}
