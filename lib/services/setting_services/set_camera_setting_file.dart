import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:psm_at_stamp/services/file_system_manager_services/write_data_to_file.dart';

Future<void> setCameraSetting({@required String camera}) async {
  await writeDataToFile(
    fileName: "cameraSetting.json",
    fileData: json.encode(
      {"camera": camera},
    ),
  );
}
