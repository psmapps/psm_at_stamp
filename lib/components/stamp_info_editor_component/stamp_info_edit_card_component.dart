import 'package:flutter/material.dart';

Widget stampInfoEditCard({
  @required String infoName,
  @required IconData infoIcon,
  @required Widget infoWidget,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10),
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(infoIcon),
              Padding(
                padding: const EdgeInsets.only(left: 10),
              ),
              Text(
                infoName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: infoWidget,
        )
      ],
    ),
  );
}
