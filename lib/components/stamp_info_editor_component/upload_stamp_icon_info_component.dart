import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as ImageResider;
import 'package:psm_at_stamp/components/button_components/app_button_components.dart';
import 'package:psm_at_stamp/components/notification_components/loading_box.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/upload_stamp_logo_services/image_uploader_service.dart';

class UploadStampIconInfoComponent extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  UploadStampIconInfoComponent({
    Key key,
    @required this.psmAtStampUser,
  }) : super(key: key);

  @override
  _UploadStampIconInfoComponentState createState() =>
      _UploadStampIconInfoComponentState();
}

class _UploadStampIconInfoComponentState
    extends State<UploadStampIconInfoComponent> {
  File imageFile;
  bool isInDelay = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> imagePicker() async {
    PickedFile pickaedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    File image = File(pickaedImage.path);
    if (!(await image.exists())) {
      throw null;
    }
    showLoadingBox(context);
    var imageResize = ImageResider.copyResize(
      ImageResider.decodeImage(image.readAsBytesSync()),
      width: 1024,
      height: 1024,
    );
    image..writeAsBytesSync(ImageResider.encodePng(imageResize));
    Navigator.pop(context);
    setState(() {
      imageFile = image;
    });
  }

  Future<void> delayTimer() async {
    isInDelay = true;
    await Future.delayed(Duration(seconds: 30));
    isInDelay = false;
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
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            "1.รูปภาพต้องมีขนาด 1024 x 1024 px หากเป็นขนาดอื่นจะถูก Resize มาเป็นขนาดตามที่กำหนดโดยอัตโนมัติ \n 2. รูปภาพไม่ควรมีพื้นหลัง (Transparent Background) \n\n ** หากพบรูปภาพฐานกิจกรรมผิดข้อกำหนด จะถูกลบและอาจไม่สามารถเปลี่ยน Logo ฐานกิจกรรมได้อีก **",
                            style: TextStyle(
                              color: Colors.white,
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
                child: Column(
                  children: <Widget>[
                    Text(
                      "ตัวอย่าง Logo หลังเปลี่ยน",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(170),
                      child: Image.file(
                        imageFile,
                        scale: 4,
                      ),
                    ),
                  ],
                ),
              ),
        imageFile == null
            ? appButtonComponent(
                title: "เลือกรูป Logo ฐานกิจกรรม",
                onPressHandler: () {
                  if (!isInDelay) {
                    imagePicker();
                    delayTimer();
                  } else {
                    showMessageBox(
                      context,
                      icon: FontAwesomeIcons.exclamationTriangle,
                      iconColor: Colors.yellow,
                      title: "กรุณารอซักครู่",
                      content:
                          "กรุณารอ 30 วินาที หลังจากการเปลี่ยนแปลง Logo ฐานกิจกรรมครั้งล่าสุด",
                    );
                  }
                },
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: appButtonComponent(
                        title: "ยกเลิก",
                        buttonColor: Colors.redAccent,
                        onPressHandler: () {
                          setState(() {
                            imageFile = null;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: appButtonComponent(
                        title: "เปลี่ยน Logo",
                        buttonColor: Colors.green,
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
                                onPressed: () async {
                                  Navigator.pop(context);
                                  try {
                                    await imageUploaderService(
                                      context,
                                      psmAtStampUser: widget.psmAtStampUser,
                                      imageFile: imageFile,
                                    );
                                  } catch (e) {
                                    showMessageBox(
                                      context,
                                      icon:
                                          FontAwesomeIcons.exclamationTriangle,
                                      iconColor: Colors.yellow,
                                      title: "เกิดข้อผิดพลาด",
                                      content:
                                          "ไม่สามารถเปลี่ยน Logo ฐานกิจกรรมได้ กรุณาลองใหม่อีกครั้ง",
                                    );
                                    return;
                                  }
                                  setState(() {
                                    imageFile = null;
                                  });
                                  showMessageBox(
                                    context,
                                    icon: FontAwesomeIcons.check,
                                    iconColor: Colors.green,
                                    title: "เปลี่ยน Logo สำเร็จ",
                                    content:
                                        "เปลี่ยน Logo ฐานกิจกรรมของคุณเรียบร้อยแล้ว",
                                  );
                                },
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
      ],
    );
  }
}
