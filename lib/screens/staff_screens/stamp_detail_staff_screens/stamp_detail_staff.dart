import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
import 'package:psm_at_stamp/components/stamp_detail_components/stamp_details_card_component.dart';
import 'package:psm_at_stamp/screens/staff_screens/stamp_info_editor_screens/stamp_info_editor_screen.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/stamp_book_services/stamp_details_constructure.dart';

class StampDetailStaff extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  StampDetailStaff({Key key, @required this.psmAtStampUser}) : super(key: key);

  @override
  _StampDetailStaffState createState() => _StampDetailStaffState();
}

class _StampDetailStaffState extends State<StampDetailStaff> {
  StampIdInfomation stampIdInfomation;
  @override
  void initState() {
    stampIdInfomation = StampIdInfomation(
      stampId: widget.psmAtStampUser.stampId,
      displayStampBadge: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StampDetailCardComponent(
              psmAtStampUser: widget.psmAtStampUser,
              stampIdInfomation: stampIdInfomation,
            ),
            signInButtonComponent(
              title: "ตั้งค่าฐานกิจกรรม",
              icon: FontAwesomeIcons.wrench,
              onPressHandler: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (route) => StampInfoEditorScreen(
                      psmAtStampUser: widget.psmAtStampUser,
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
