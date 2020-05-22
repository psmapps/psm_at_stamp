import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/stamp_info_editor_component/stamp_info_edit_component.dart';
import 'package:psm_at_stamp/components/stamp_info_editor_component/upload_stamp_icon_info_component.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

class StampInfoEditorScreen extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  StampInfoEditorScreen({Key key, @required this.psmAtStampUser})
      : super(key: key);

  @override
  _StampInfoEditorScreenState createState() => _StampInfoEditorScreenState();
}

class _StampInfoEditorScreenState extends State<StampInfoEditorScreen> {
  StreamSubscription stampSteam;
  String categories;
  String stampDetail;
  String stampLocation;
  bool isOpen;
  String iconUrl;
  TextEditingController stampNameController = TextEditingController();
  @override
  void initState() {
    subscribeToStamp();
    super.initState();
  }

  @override
  void dispose() {
    stampSteam.cancel();
    super.dispose();
  }

  void subscribeToStamp() {
    stampSteam = Firestore.instance
        .collection("Stamp_Data")
        .document(widget.psmAtStampUser.stampId)
        .snapshots()
        .listen((doc) {
      if (!doc.exists) {
        return Navigator.popUntil(context, (route) => route.isFirst);
      }
      setState(() {
        stampNameController.text = doc.data["name"];
        stampLocation = doc.data["location"];
        stampDetail = doc.data["detail"];
        isOpen = doc.data["isOpen"];
        categories = doc.data["categories"];
        iconUrl = doc.data["iconUrl"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Icon(FontAwesomeIcons.wrench),
            Padding(
              padding: const EdgeInsets.only(left: 10),
            ),
            Text(
              "ตั้งค่าฐานกิจกรรม",
              style: TextStyle(
                fontFamily: "Sukhumwit",
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        backgroundColor: Color.fromRGBO(31, 31, 31, 1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              stampInfoEditComponent(
                infoName: "ชื่อฐานกิจกรรม",
                infoIcon: FontAwesomeIcons.tag,
                textController: stampNameController,
              ),
              stampInfoEditComponent(
                infoName: "Logo ฐานกิจกรรม",
                infoIcon: FontAwesomeIcons.photoVideo,
                infoWidget: UploadStampIconInfoComponent(
                  psmAtStampUser: widget.psmAtStampUser,
                  categories: categories,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
