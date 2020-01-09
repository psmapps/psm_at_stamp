import 'package:flutter/material.dart';

void showMessageBox(BuildContext context, bool showIndicator, String title,
    String message) async {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      if (showIndicator) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        );
      } else {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("ปิด"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    },
  );
}
