import 'package:flutter/material.dart';
import 'package:psm_at_stamp/screens/welcome_screen.dart';

void main() => runApp(PSMATSTAMP());

class PSMATSTAMP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PSM @ STAMP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}
