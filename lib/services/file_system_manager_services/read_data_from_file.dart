import 'dart:io';

import 'package:flutter/material.dart';
import 'package:psm_at_stamp/services/file_system_manager_services/get_file.dart';

Future<String> readDataFromFile({@required String fileName}) async {
  try {
    final File file = await getFile(fileName: fileName);
    return await file.readAsString();
  } catch (e) {
    throw e;
  }
}
