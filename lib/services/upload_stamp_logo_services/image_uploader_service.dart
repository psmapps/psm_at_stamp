import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/notification_components/loading_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

Future<void> imageUploaderService(
  BuildContext context, {
  @required PsmAtStampUser psmAtStampUser,
  @required File imageFile,
}) async {
  showLoadingBox(context, loadingMessage: "กำลังเปลี่ยน Logo ฐานกิจกรรม");
  StorageReference storageReference = FirebaseStorage(
          storageBucket: "gs://stamp_icons")
      .ref()
      .child(psmAtStampUser.stampId + "/" + psmAtStampUser.stampId + ".png");
  StorageUploadTask uploadTask = storageReference.putFile(imageFile);
  await uploadTask.onComplete;
  String downloadUri = await storageReference.getDownloadURL();
  logger.d(downloadUri);
  try {
    await FirebaseFirestore.instance
        .collection("Stamp_Data")
        .doc(psmAtStampUser.stampId)
        .update({
      "iconUrl": downloadUri,
    });
  } catch (e) {
    logger.e(e);
    Navigator.pop(context);
    throw false;
  }
  Navigator.pop(context);
  return;
}
