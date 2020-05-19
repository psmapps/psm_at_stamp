import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

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
  File _image;
  Future<void> pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _image == null ? Container() : Image.file(_image),
        signInButtonComponent(
          title: "อัพโหลดรูป Logo ฐานกิจกรรม",
          onPressHandler: () {
            pickImage();
          },
        ),
      ],
    );
  }
}
