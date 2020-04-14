import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget signInButtonComponent(
    {@required String title,
    @required IconData icon,
    @required Function onPressHandler}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: onPressHandler,
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Row(
                children: <Widget>[
                  FaIcon(icon, size: 23),
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                            fontFamily: "Sukhumwit",
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ),
  );
}
