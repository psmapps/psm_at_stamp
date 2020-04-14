import 'package:flutter/material.dart';
import 'package:psm_at_stamp/screens/signin_screen.dart';

Future<void> welcomeCredentialCheck(BuildContext context) {
  return Future.delayed(Duration(seconds: 3), () {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInScreen()));
  });
}
