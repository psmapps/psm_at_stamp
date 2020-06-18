import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/screens/home_screens/screen_widget_constructure.dart';
import 'package:psm_at_stamp/screens/my_account_screens/my_account_screen.dart';
import 'package:psm_at_stamp/screens/staff_screens/stamp_detail_staff_screens/stamp_detail_staff.dart';
import 'package:psm_at_stamp/screens/stamp_book_screens/stamp_book_screen.dart';
import 'package:psm_at_stamp/screens/staff_screens/stamp_distributing_screens/stamp_distributing_screen.dart';
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
            child: Text(
              "สมุดแสตมป์",
              style: TextStyle(
                fontFamily: "Sukhumwit",
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.userAlt),
            child: Text(
              "บัญชีของฉัน",
              style: TextStyle(
                fontFamily: "Sukhumwit",
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        tabBarCount: 2,
      );
      break;
    case PsmAtStampUserPermission.staff:
      return ScreenWidget(
        screenList: [
          StampDetailStaff(
            psmAtStampUser: psmAtStampUser,
          ),
          StampDistributingScreen(
            psmAtStampUser: psmAtStampUser,
            distributingType: DistributingType.qrCode,
          ),
          StampDistributingScreen(
            psmAtStampUser: psmAtStampUser,
            distributingType: DistributingType.manual,
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
                fontSize: 13,
                fontFamily: "Sukhumwit",
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.qrcode),
            child: Text(
              "แจกแสตมป์",
              style: TextStyle(
                fontSize: 13,
                fontFamily: "Sukhumwit",
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.pencilRuler),
            child: Text(
              "เพิ่มแสตมป์",
              style: TextStyle(
                fontSize: 13,
                fontFamily: "Sukhumwit",
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.userAlt),
            child: Text(
              "บัญชีของฉัน",
              style: TextStyle(
                fontSize: 13,
                fontFamily: "Sukhumwit",
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        tabBarCount: 4,
      );

      break;
    case PsmAtStampUserPermission.administrator:
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
            child: Text(
              "สมุดแสตมป์",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Sukhumwit",
              ),
            ),
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.userAlt),
            child: Text(
              "บัญชีของฉัน",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Sukhumwit",
              ),
            ),
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
