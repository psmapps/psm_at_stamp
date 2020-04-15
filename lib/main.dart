import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:psm_at_stamp/screens/welcome_screen.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LineSDK.instance.setup("1588292412").then((_) {
    logger.d("LINE SDK is prepared");
  });
  runApp(PSMATSTAMP());
}

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
