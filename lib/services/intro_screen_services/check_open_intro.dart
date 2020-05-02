import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:psm_at_stamp/screens/intro_slider_screens/intro_slider_screens.dart';
import 'package:psm_at_stamp/services/file_system_manager_services/read_data_from_file.dart';
import 'package:psm_at_stamp/services/file_system_manager_services/write_data_to_file.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

Future<void> checkOpenIntro(BuildContext context,
    {@required PsmAtStampUser psmAtStampUser}) async {
  Map<String, dynamic> data;
  try {
    data = json.decode(
      await readDataFromFile(fileName: "intro.json"),
    );
  } catch (e) {
    await writeDataToFile(
      fileName: "intro.json",
      fileData: json.encode(
        {"displayIntro": "false"},
      ),
    );
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => IntroSliderScreen(
          psmAtStampUser: psmAtStampUser,
        ),
      ),
    );
  }

  if (data["displayIntro"]) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => IntroSliderScreen(
          psmAtStampUser: psmAtStampUser,
        ),
      ),
    );
  }
  return;
}
