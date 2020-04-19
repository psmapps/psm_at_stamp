import 'dart:io';

import 'package:flutter/material.dart';
import 'package:psm_at_stamp/services/file_system_manager_services/get_file.dart';

Future<void> deleteFile({@required String fileName}) async {
  try {
    File file = await getFile(fileName: fileName);
    return await file.delete();
  } catch (e) {
    throw e;
  }
}
