import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:psm_at_stamp/services/file_system_manager_services/write_data_to_file.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

Future<void> saveCredentialToFile(
    {@required PsmAtStampUser psmAtStampUser}) async {
  String _permission;
  switch (psmAtStampUser.permission) {
    case PsmAtStampUserPermission.administrator:
      _permission = "Administrator";
      break;
    case PsmAtStampUserPermission.staff:
      _permission = "Staff";
      break;
    case PsmAtStampUserPermission.student:
      _permission = "Student";
      break;
  }
  Map<String, dynamic> fileData = {
    "prefix": psmAtStampUser.prefix,
    "name": psmAtStampUser.name,
    "surname": psmAtStampUser.surname,
    "userId": psmAtStampUser.userId,
    "studentId": psmAtStampUser.studentId,
    "year": psmAtStampUser.year,
    "room": psmAtStampUser.room,
    "permission": _permission,
    "accessToken": psmAtStampUser.accessToken,
    "udid": psmAtStampUser.udid,
    "displayName": psmAtStampUser.displayName,
    "profileImageUrl": psmAtStampUser.profileImageUrl
  };
  return await writeDataToFile(
      fileName: "credential.json", fileData: json.encode(fileData));
}
