import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/stamp_info_editor_services/update_stamp_detail.dart';

class StampInfoEditTextInput extends StatefulWidget {
  final String settingName;
  final int maxTextFieldLine;
  final int maxLength;
  final PsmAtStampUser psmAtStampUser;
  StampInfoEditTextInput({
    Key key,
    @required this.settingName,
    @required this.psmAtStampUser,
    @required this.maxTextFieldLine,
    @required this.maxLength,
  }) : super(key: key);

  @override
  _StampInfoEditTextInputState createState() => _StampInfoEditTextInputState();
}

class _StampInfoEditTextInputState extends State<StampInfoEditTextInput> {
  TextEditingController settingTextController = TextEditingController();
  StreamSubscription settingSteam;
  String beforeChagneString = "";
  int currentLength = 0;
  bool showSaveButton = false;
  @override
  void initState() {
    subscribeToSetting();
    super.initState();
  }

  void subscribeToSetting() {
    settingSteam = Firestore.instance
        .collection("Stamp_Data")
        .document(widget.psmAtStampUser.stampId)
        .snapshots()
        .listen((data) {
      if (!data.exists) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
      setState(() {
        settingTextController.text = data.data[widget.settingName];
        currentLength = data.data[widget.settingName].toString().length;
        beforeChagneString = data.data[widget.settingName];
      });
    });
  }

  @override
  void dispose() {
    settingSteam.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: settingTextController,
            maxLines: widget.maxTextFieldLine,
            autocorrect: false,
            style: TextStyle(
              fontFamily: "Sukhumwit",
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            decoration: InputDecoration(
              suffix: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(5),
                child: Text(
                  currentLength.toString() + "/" + widget.maxLength.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Sukhumwit",
                  ),
                ),
              ),
            ),
            onTap: () {
              setState(() {
                showSaveButton = true;
              });
            },
            onChanged: (value) {
              setState(() {
                currentLength = value.length;
              });
              if (currentLength >= widget.maxLength) {
                int excessText = currentLength - widget.maxLength;
                setState(
                  () {
                    settingTextController.text =
                        settingTextController.text.substring(
                      0,
                      settingTextController.text.length - excessText,
                    );
                    currentLength = settingTextController.text.length;
                  },
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
          ),
          showSaveButton
              ? Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 2,
                          child: signInButtonComponent(
                            title: "จบการแก้ไข",
                            buttonColor: Colors.grey,
                            onPressHandler: () {
                              setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              });
                            },
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: signInButtonComponent(
                            title: "บันทึกการแก้ไข",
                            buttonColor: Colors.green,
                            onPressHandler: () async {
                              try {
                                await updateStampDetail(
                                  context,
                                  setting: widget.settingName,
                                  value: settingTextController.text,
                                  psmAtStampUser: widget.psmAtStampUser,
                                );
                              } catch (e) {
                                return;
                              }
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                showSaveButton = false;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    signInButtonComponent(
                      title: "ยกเลิกการแก้ไข",
                      buttonColor: Colors.red[300],
                      onPressHandler: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          settingTextController.text = beforeChagneString;
                          currentLength = settingTextController.text.length;
                          showSaveButton = false;
                        });
                      },
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
