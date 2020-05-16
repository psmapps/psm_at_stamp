import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
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
  TextEditingController stampName = TextEditingController();
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
                textController: stampName,
              ),
              stampInfoEditComponent(
                infoName: "Icon ฐานกิจกรรม",
                infoIcon: FontAwesomeIcons.photoVideo,
                infoWidget: UploadStampIconInfoComponent(
                  psmAtStampUser: widget.psmAtStampUser,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
