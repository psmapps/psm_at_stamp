import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/register_screen_components/register_screen_textfield_component.dart';
import 'package:psm_at_stamp/components/register_screen_components/register_staff_component.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/register_services/psmatstampregister_constructure.dart';
import 'package:psm_at_stamp/services/register_services/register_validate_service.dart';

class RegisterScreen extends StatefulWidget {
  final PsmAtStampRegister psmAtStampRegister;

  RegisterScreen({
    Key key,
    @required this.psmAtStampRegister,
  }) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
  TextEditingController stampLinkCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 31, 31, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(40, 40, 40, 1),
        title: Text(
          "ผูกบัญชีกับรหัสนักเรียนหรือรหัสบัญชี",
          style: TextStyle(
            fontFamily: "Sukhumwit",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                child: Center(
                  child: Image.asset(
                    "assets/images/icons/icon.png",
                    scale: 5,
                  ),
                ),
              ),
              Text(
                "กรุณากรอกรหัสนักเรียน หรือ รหัสบัญชี ของคุณ เพื่อทำการผูกบัญชี",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: "Sukhumwit",
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
              widget.psmAtStampRegister.permission ==
                      PsmAtStampUserPermission.staff
                  ? registerStaffSector(
                      context,
                      textEditingController: stampLinkCode,
                    )
                  : Container(),
              signInButtonComponent(
                title: "ผูกรหัสนักเรียนหรือรหัสบัญชีนี้",
                onPressHandler: () {
                  String studentId = studentIdTextDigit1.text +
                      studentIdTextDigit2.text +
                      studentIdTextDigit3.text +
                      studentIdTextDigit4.text +
                      studentIdTextDigit5.text +
                      studentIdTextDigit6.text;
                  registerValidate(
                    context,
                    studentId: studentId,
                    psmAtStampRegister: widget.psmAtStampRegister,
                    stampLinkCode: stampLinkCode.text,
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
