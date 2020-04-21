import 'package:flutter/material.dart';
import 'package:psm_at_stamp/services/file_system_manager_services/write_data_to_file.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

Future<void> saveCredentialToFile(
    {@required PsmAtStampUser psmAtStampUser}) async {
  return await writeDataToFile(
      fileName: "credential.json", fileData: psmAtStampUser.exportToString());
}
