import 'package:flutter/material.dart';
import 'package:psm_at_stamp/services/welcome_screen_services.dart/welcome_screen_services.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    welcomeCredentialCheck(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 31, 31, 1),
      body: Center(
        child: Image.asset("assets/images/icons/icon.png"),
      ),
    );
  }
}
