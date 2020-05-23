import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File> imagePicker() async {
  File image = await ImagePicker.pickImage(source: ImageSource.gallery);
  if (!(await image.exists())) {
    throw null;
  }
  return image;
}
