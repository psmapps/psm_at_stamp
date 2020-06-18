import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/stamp_info_editor_services/change_stamp_status.dart';

class StampInfoEditStampStatus extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  final String settingName;
  StampInfoEditStampStatus({
    Key key,
    @required this.psmAtStampUser,
    @required this.settingName,
  }) : super(key: key);

  @override
  _StampInfoEditStampStatusState createState() =>
      _StampInfoEditStampStatusState();
}

class _StampInfoEditStampStatusState extends State<StampInfoEditStampStatus> {
  StreamSubscription settingSteam;
  bool isOpen = false;
  bool isInDelay = false;
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
        isOpen = data.data[widget.settingName];
      });
    });
  }

  Future<void> delayTimer() async {
    isInDelay = true;
    await Future.delayed(Duration(seconds: 30));
    isInDelay = false;
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Switch(
            value: isOpen,
            onChanged: (value) {
              if (!isInDelay) {
                changeStampStatus(
                  context,
                  value: value,
                  psmAtStampUser: widget.psmAtStampUser,
                );
                delayTimer();
              } else {
                showMessageBox(
                  context,
                  icon: FontAwesomeIcons.exclamationTriangle,
                  iconColor: Colors.yellow,
                  title: "กรุณารอซักครู่",
                  content:
                      "กรุณารอ 30 วินาที หลังจากการเปลี่ยนแปลงสถานะฐานกิจกรรมครั้งล่าสุด",
                );
              }
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
            inactiveTrackColor: Colors.redAccent[100],
            inactiveThumbColor: Colors.red,
          ),
          Container(
            decoration: BoxDecoration(
              color: isOpen ? Colors.green : Colors.redAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(10),
            child: Text(
              isOpen ? "เปิดให้เข้าเล่นกิจกรรม" : "ไม่เปิดให้เข้าเล่นกิจกรรม",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
