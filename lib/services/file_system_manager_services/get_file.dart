import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<File> getFile({@required String fileName}) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    return File(directory.path + "/" + fileName);
  } catch (e) {
    throw e;
  }
}
