import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
import 'package:psm_at_stamp/components/stamp_detail_components/stamp_details_card_component.dart';
import 'package:psm_at_stamp/screens/staff_screens/stamp_info_editor_screens/stamp_info_editor_screen.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/stamp_book_services/stamp_details_constructure.dart';

class StampDetailStaff extends StatelessWidget {
  final PsmAtStampUser psmAtStampUser;
  const StampDetailStaff({Key key, @required this.psmAtStampUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StampDetailCardComponent(
              psmAtStampUser: psmAtStampUser,
              stampIdInfomation: StampIdInfomation(
                stampId: psmAtStampUser.stampId,
                displayStampBadge: false,
              ),
            ),
            signInButtonComponent(
              title: "ตั้งค่าฐานกิจกรรม",
              icon: FontAwesomeIcons.wrench,
              onPressHandler: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (route) => StampInfoEditorScreen(
                      psmAtStampUser: psmAtStampUser,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
            ),
          ],
        ),
      ),
    );
  }
}
