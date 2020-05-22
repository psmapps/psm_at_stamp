import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as ImageResider;
import 'package:psm_at_stamp/components/notification_components/loading_box.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

Future<void> imagePickerAndUploaderService(
  BuildContext context, {
  @required String categories,
  @required PsmAtStampUser psmAtStampUser,
}) async {
  var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  if (!(await image.exists())) {
    return;
  }
  showLoadingBox(context, loadingMessage: "กำลังเปลี่ยน Logo ฐานกิจกรรม");
  var thumbnail = ImageResider.copyResize(
    ImageResider.decodeImage(image.readAsBytesSync()),
    width: 1024,
    height: 1024,
  );
  image..writeAsBytesSync(ImageResider.encodePng(thumbnail));

  StorageReference storageReference =
      FirebaseStorage(storageBucket: "gs://stamp_icons")
          .ref()
          .child(categories + "/" + psmAtStampUser.stampId + ".png");
  StorageUploadTask uploadTask = storageReference.putFile(image);

  await uploadTask.onComplete;

  String downloadUri = await storageReference.getDownloadURL();
  logger.d(downloadUri);

  try {
    await Firestore.instance
        .collection("Stamp_Data")
        .document(psmAtStampUser.stampId)
        .updateData({
      "iconUrl": downloadUri,
    });
  } catch (e) {
    logger.e(e);
  }
  Navigator.pop(context);
  showMessageBox(
    context,
    title: "สำเร็จ",
    content: "เปลี่ยนรูปฐานกิจกรรมสำเร็จ",
    icon: FontAwesomeIcons.check,
    iconColor: Colors.green,
  );
}
