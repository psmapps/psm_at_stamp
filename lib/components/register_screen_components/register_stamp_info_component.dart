import 'package:flutter/material.dart';

Widget registerStampInfo({@required String index, @required String data}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        index,
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10),
      ),
      Flexible(
        child: Text(
          data,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}
