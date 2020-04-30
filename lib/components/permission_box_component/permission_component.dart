import 'package:flutter/material.dart';

Widget permissionComponent({
  @required IconData icon,
  @required String permissionTitle,
  @required Widget permissionStatus,
}) {
  return Row(
    children: <Widget>[
      Icon(
        icon,
        size: 20,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10),
      ),
      Text(
        permissionTitle,
        style: TextStyle(
          fontSize: 20,
          fontFamily: "Sukhumwit",
          fontWeight: FontWeight.bold,
        ),
      ),
      Spacer(),
      permissionStatus,
    ],
  );
}
