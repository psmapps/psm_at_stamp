import 'dart:convert';

import 'package:psm_at_stamp/services/file_system_manager_services/read_data_from_file.dart';
import 'package:psm_at_stamp/services/file_system_manager_services/write_data_to_file.dart';

Future<Map<String, dynamic>> getCameraSetting() async {
  try {
    return json.decode(await readDataFromFile(fileName: "cameraSetting.json"));
  } catch (e) {
    writeDataToFile(
      fileName: "cameraSetting.json",
      fileData: json.encode(
        {"camera": "-1"},
      ),
    );
    return {"camera": "-1"};
  }
}
