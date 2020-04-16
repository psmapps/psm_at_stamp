import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget registerScreenTextFieldComponent(BuildContext context,
    {@required FocusNode beforeFocusNode,
    @required FocusNode currentFocusNode,
    @required FocusNode nextFocusNode,
    @required String hintText}) {
  return Flexible(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        focusNode: currentFocusNode,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[850]),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
        onChanged: (change) {
          if (change.length <= 0) {
            if (beforeFocusNode != null) {
              FocusScope.of(context).requestFocus(beforeFocusNode);
            }
            return;
          }
          if (change.length >= 1) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).requestFocus(FocusNode());
            }
            return;
          }
        },
      ),
    ),
  );
}
