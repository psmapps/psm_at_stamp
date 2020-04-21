import 'dart:convert';

import 'package:psm_at_stamp/services/file_system_manager_services/read_data_from_file.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/permission_converter_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/signin_service_converter_service.dart';

Future<PsmAtStampUser> readCredentailFromFile() async {
  String data;
  try {
    data = await readDataFromFile(fileName: "credential.json");
  } catch (e) {
    throw e;
  }
  Map<String, dynamic> credentialDecode = json.decode(data);
  PsmAtStampUser psmAtStampUser = PsmAtStampUser(
    prefix: credentialDecode["prefix"],
    name: credentialDecode["name"],
    surname: credentialDecode["surname"],
    userId: credentialDecode["userId"],
    studentId: credentialDecode["studentId"],
    year: credentialDecode["year"],
    room: credentialDecode["room"],
    permission: psmAtStampStringToPermission(
        permissionString: credentialDecode["permission"]),
    signInServices: psmAtStampStringToSignInService(
        signInService: credentialDecode["signInServices"]),
    accessToken: credentialDecode["accessToken"],
    udid: credentialDecode["udid"],
    displayName: credentialDecode["displayName"] ?? "PSM @ STAMP",
    profileImageUrl: credentialDecode["profileImageUrl"],
  );
  return psmAtStampUser;
}
