import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/button_components/app_button_components.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/components/register_screen_components/register_screen_textfield_component.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/stamp_distributing_services/manual_distributing_service.dart';

class ManualDistributing extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  ManualDistributing({
    Key key,
    @required this.psmAtStampUser,
  }) : super(key: key);

  @override
  _ManualDistributingState createState() => _ManualDistributingState();
}

class _ManualDistributingState extends State<ManualDistributing> {
  FocusNode studentIdDigit1 = FocusNode();
  FocusNode studentIdDigit2 = FocusNode();
  FocusNode studentIdDigit3 = FocusNode();
  FocusNode studentIdDigit4 = FocusNode();
  FocusNode studentIdDigit5 = FocusNode();
  FocusNode studentIdDigit6 = FocusNode();
  TextEditingController studentIdTextDigit1 = TextEditingController();
  TextEditingController studentIdTextDigit2 = TextEditingController();
  TextEditingController studentIdTextDigit3 = TextEditingController();
  TextEditingController studentIdTextDigit4 = TextEditingController();
  TextEditingController studentIdTextDigit5 = TextEditingController();
  TextEditingController studentIdTextDigit6 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(31, 31, 31, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  "กรอกรหัสนักเรียนที่ต้องการเพิ่มแสตมป์ลงในช่องด่านล่างนี้",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Sukhumwit",
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      registerScreenTextFieldComponent(
                        context,
                        textEditingController: studentIdTextDigit1,
                        beforeFocusNode: null,
                        currentFocusNode: studentIdDigit1,
                        nextFocusNode: studentIdDigit2,
                        hintText: "0",
                      ),
                      registerScreenTextFieldComponent(
                        context,
                        textEditingController: studentIdTextDigit2,
                        beforeFocusNode: studentIdDigit1,
                        currentFocusNode: studentIdDigit2,
                        nextFocusNode: studentIdDigit3,
                        hintText: "0",
                      ),
                      registerScreenTextFieldComponent(
                        context,
                        textEditingController: studentIdTextDigit3,
                        beforeFocusNode: studentIdDigit2,
                        currentFocusNode: studentIdDigit3,
                        nextFocusNode: studentIdDigit4,
                        hintText: "0",
                      ),
                      registerScreenTextFieldComponent(
                        context,
                        textEditingController: studentIdTextDigit4,
                        beforeFocusNode: studentIdDigit3,
                        currentFocusNode: studentIdDigit4,
                        nextFocusNode: studentIdDigit5,
                        hintText: "0",
                      ),
                      registerScreenTextFieldComponent(
                        context,
                        textEditingController: studentIdTextDigit5,
                        beforeFocusNode: studentIdDigit4,
                        currentFocusNode: studentIdDigit5,
                        nextFocusNode: studentIdDigit6,
                        hintText: "0",
                      ),
                      registerScreenTextFieldComponent(
                        context,
                        textEditingController: studentIdTextDigit6,
                        beforeFocusNode: studentIdDigit5,
                        currentFocusNode: studentIdDigit6,
                        nextFocusNode: null,
                        hintText: "0",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
          ),
          appButtonComponent(
            title: "เพิ่มแสตมป์ให้กับรหัสนักเรียนนี้",
            icon: FontAwesomeIcons.plusCircle,
            buttonColor: Colors.yellow,
            onPressHandler: () async {
              String studentId = studentIdTextDigit1.text +
                  studentIdTextDigit2.text +
                  studentIdTextDigit3.text +
                  studentIdTextDigit4.text +
                  studentIdTextDigit5.text +
                  studentIdTextDigit6.text;
              studentIdTextDigit1.text = "";
              studentIdTextDigit2.text = "";
              studentIdTextDigit3.text = "";
              studentIdTextDigit4.text = "";
              studentIdTextDigit5.text = "";
              studentIdTextDigit6.text = "";
              try {
                await manualDistributingService(
                  context: context,
                  psmAtStampUser: widget.psmAtStampUser,
                  studentId: studentId,
                );
              } on PlatformException catch (e) {
                showMessageBox(
                  context,
                  icon: FontAwesomeIcons.exclamationTriangle,
                  iconColor: Colors.yellow,
                  title: "เกิดข้อผิดพลาด",
                  content: e.details + "(Code: " + e.code + ")",
                );
                return;
              }
              return showMessageBox(
                context,
                icon: FontAwesomeIcons.check,
                iconColor: Colors.green,
                title: "สำเร็จ",
                content: "เพิ่มแสตมป์ให้กับรหัสนักเรียน (" +
                    studentId +
                    ") เรียบร้อยแล้ว",
              );
            },
          )
        ],
      ),
    );
  }
}
