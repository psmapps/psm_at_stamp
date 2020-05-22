import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/upload_stamp_logo_services/image_picker_and_uploader_service.dart';

class UploadStampIconInfoComponent extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  final String categories;
  UploadStampIconInfoComponent({
    Key key,
    @required this.psmAtStampUser,
    @required this.categories,
  }) : super(key: key);

  @override
  _UploadStampIconInfoComponentState createState() =>
      _UploadStampIconInfoComponentState();
}

class _UploadStampIconInfoComponentState
    extends State<UploadStampIconInfoComponent> {
  File imageFile;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        imageFile == null
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.blueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "ข้อกำหนดของ Logo​ ฐานกิจกรรม",
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontFamily: "Sukhumwit",
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            "1.รูปภาพต้องมีขนาด 1024 x 1024 px หากเป็นขนาดอื่นจะถูก Resize มาเป็นขนาดตามที่กำหนดโดยอัตโนมัติ \n\n2.รูปภาพพื้นหลังต้องไม่มีสี (Transparent Background) \n\n ** หากพบรูปภาพฐานกิจกรรมผิดข้อกำหนด จะถูกลบและอาจไม่สามารถเปลี่ยน Logo ฐานกิจกรรมได้อีก **",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Sukhumwit",
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(170),
                  child: Image.file(
                    imageFile,
                    scale: 4,
                  ),
                ),
              ),
        signInButtonComponent(
          title: "อัพโหลดรูป Logo ฐานกิจกรรม",
          onPressHandler: () {
            showMessageBox(
              context,
              icon: FontAwesomeIcons.handshake,
              iconColor: Colors.redAccent,
              title: "ข้อกำหนดของ Logo",
              content:
                  "หากคุณกดปุ่มเครื่องหมายถูกต้อง คุณยืนยันว่าคุณได้อ่านข้อกำหนดของ Logo ฐานกิจกรรมแล้ว และรูปภาพที่อัพโหลดขึ้นมาถูกต้องตามข้อกำหนด",
              actionsButton: [
                IconButton(
                  icon: Icon(FontAwesomeIcons.timesCircle),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.checkCircle),
                  onPressed: () {
                    Navigator.pop(context);
                    imagePickerAndUploaderService(
                      context,
                      categories: widget.categories,
                      psmAtStampUser: widget.psmAtStampUser,
                    );
                  },
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
