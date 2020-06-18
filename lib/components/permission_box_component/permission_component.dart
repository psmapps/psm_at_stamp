import 'package:flutter/material.dart';

Widget permissionComponent({
  @required IconData icon,
  @required String permissionTitle,
  @required Widget permissionStatus,
}) {
  return Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Icon(
              icon,
              size: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
          ),
          Flexible(
            flex: 2,
            child: Text(
              permissionTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      permissionStatus,
    ],
  );
}
