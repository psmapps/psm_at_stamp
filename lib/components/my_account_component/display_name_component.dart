import 'package:flutter/material.dart';

Widget displayNameComponent({@required String displayName}) {
  if (displayName.length > 21) {
    int removeLength = 21 - displayName.length + 3;
    displayName = displayName.substring(0, displayName.length - removeLength);
    displayName = displayName + "...";
  }
  return Text(
    displayName,
    style: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
    maxLines: 1,
  );
}
