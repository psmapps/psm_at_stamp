import 'package:flutter/material.dart';

Widget stampInfoEditComponent({
  @required String infoName,
  @required IconData infoIcon,
  TextEditingController textController,
  Widget infoWidget,
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
                  fontFamily: "Sukhumwit",
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: textController != null
              ? TextField(
                  controller: textController,
                )
              : infoWidget,
        )
      ],
    ),
  );
}
