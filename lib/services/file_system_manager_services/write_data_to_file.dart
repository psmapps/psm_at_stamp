import 'dart:io';

import 'package:flutter/material.dart';
import 'package:psm_at_stamp/services/file_system_manager_services/get_file.dart';

Future<void> writeDataToFile(
    {@required String fileName, @required String fileData}) async {
  try {
    File file = await getFile(fileName: fileName);
    return file.writeAsString(fileData);
  } catch (e) {
    throw e;
  }
}
