import 'package:flutter/material.dart';

Widget stampDetailComponent({
  @required IconData iconData,
  @required String detailIndex,
  @required Widget detail,
  Color iconColor,
}) {
  return Flexible(
    child: Container(
      height: 183,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[500],
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: Row(
              children: <Widget>[
                Icon(
                  iconData,
                  size: 25,
                  color: iconColor ?? Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                ),
                Flexible(
                  child: Text(
                    detailIndex,
                    style: TextStyle(
                      fontFamily: "Sukhumwit",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                )
              ],
            ),
          ),
          detail,
        ],
      ),
    ),
  );
}
