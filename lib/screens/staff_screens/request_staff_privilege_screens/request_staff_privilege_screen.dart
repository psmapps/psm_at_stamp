import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/button_components/app_button_components.dart';
import 'package:psm_at_stamp/components/register_screen_components/register_staff_component.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/register_services/register_staff/register_staff_add_to_request.dart';

class RequestStaffPrivilegeScreen extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  RequestStaffPrivilegeScreen({
    Key key,
    @required this.psmAtStampUser,
  }) : super(key: key);

  @override
  _RequestStaffPrivilegeScreenState createState() =>
      _RequestStaffPrivilegeScreenState();
}

class _RequestStaffPrivilegeScreenState
    extends State<RequestStaffPrivilegeScreen> {
  TextEditingController stampLinkCodeTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(90, 90, 90, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(31, 31, 31, 1),
        title: Text(
          "ขอสิทธิการเป็น Staff ฐานกิจกรรม",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            registerStaffSector(
              context,
              textEditingController: stampLinkCodeTextController,
            ),
            appButtonComponent(
              title: "ขอสิทธิการเป็น Staff",
              icon: FontAwesomeIcons.userAlt,
              onPressHandler: () {
                registerStaffAddToRequest(
                  context,
                  psmAtStampUser: widget.psmAtStampUser,
                  stampLinkCode: stampLinkCodeTextController.text,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
