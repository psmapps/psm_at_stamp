import 'package:flutter/material.dart';

Widget registerStaffSector() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
    child: Column(
      children: <Widget>[
        Text(
          "กรุณากรอกรหัสฐานกิจกรรมที่คุณได้รับมอบหมายให้ดูแล",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontFamily: "Sukhumwit",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        TextField(
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        )
      ],
    ),
  );
}
