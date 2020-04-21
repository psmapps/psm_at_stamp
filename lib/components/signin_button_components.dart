import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// signInButtonComponent is used to create sign in button signin page and the others
/// * Required
/// [title, onPressHandler]
/// * Optional
/// [icon, textAlign]
Widget signInButtonComponent({
  @required String title,
  @required Function onPressHandler,
  Color buttonColor,
  TextAlign textAlign,
  IconData icon,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            color: buttonColor ?? Colors.grey[100],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: onPressHandler,
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Row(
                children: <Widget>[
                  icon != null ? FaIcon(icon, size: 23) : Container(),
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                            fontFamily: "Sukhumwit",
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                        textAlign: textAlign ?? TextAlign.start,
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
