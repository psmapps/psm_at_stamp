import 'package:flutter/material.dart';

///signInTextField is used to build textfield in signin page
/// * Required
/// [controller, labelText]
/// * Optional
/// [isObsecureText, keyboardType, onSubmitted, focusNode]
Widget signInTextField({
  @required TextEditingController controller,
  @required String labelText,
  Function(String) onSubmitted,
  FocusNode focusNode,
  bool isObsecureText,
  TextInputType keyboardType,
}) {
  return TextField(
    controller: controller,
    focusNode: focusNode,
    obscureText: isObsecureText ?? false,
    keyboardType: keyboardType ?? TextInputType.text,
    onSubmitted: onSubmitted ?? (submitted) {},
    style:
        TextStyle(color: Colors.white, fontSize: 24, fontFamily: "Sukhumwit"),
    decoration: InputDecoration(
      labelText: labelText,
      alignLabelWithHint: true,
      labelStyle: TextStyle(
        color: Colors.grey[600],
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      hoverColor: Colors.white,
    ),
  );
}
