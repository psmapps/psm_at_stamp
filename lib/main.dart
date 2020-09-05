import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:psm_at_stamp/screens/welcome_screen.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  LineSDK.instance.setup("1588292412").then((_) {
    logger.d("LINE SDK is prepared");
  });

  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(PSMATSTAMP());
}

class PSMATSTAMP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PSM @ STAMP',
        theme: ThemeData(
          fontFamily: "Sukhumwit",
          primarySwatch: Colors.blue,
        ),
        home: WelcomeScreen(),
      ),
    );
  }
}
