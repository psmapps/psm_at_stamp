import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PSM @ STAMP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Sukhumvit',
      ),
      home: welcomePage(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics)
      ],
    );
  }
}

class welcomePage extends StatefulWidget {

  @override
  _welcomePageState createState() => _welcomePageState();
}

class _welcomePageState extends State<welcomePage> {

  void startUserChecking() async{
    print("AccessToken> " + await getAccessToken());
    try{
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("Internet> Connected");
        
      }
    } on SocketException catch (e) {
      print(e.message);
      print("Internet> Not connected!");
      showMessageBox("เข้าสู่โหมด Offline", "ไม่สามารถติดต่อกับ PSM @ STAMP ได้ ระบบจะใช้ Offline Mode อัตโนมัติ");
    }
  }

  Future verifyAccessToken() async{
    try {
      final result = await LineSDK.instance.verifyAccessToken();
      print(result.data);
      return 1;
    } on PlatformException catch (e) {
      print(e.message);
      return 0;
    }
  }

  Future getAccessToken() async{
    try {
      final result = await LineSDK.instance.currentAccessToken;
        return result.value;
    } on PlatformException catch (e) {
      print(e.message);
      return 0;
    }
  }

  void showMessageBox(String title, String message) async{
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("Teest"),
              onPressed: () {
                print("Test");
              },)
          ],
        );
      }
    );
  }



  void initLineSDK() {
    LineSDK.instance.setup("1588292412").then((_){
        print("LINESDK is prepared");
    });
  }

  void initState(){
    initLineSDK();
    startUserChecking();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 43, 43, 1),
      body: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30),
              child: Image.asset('assets/image/full_logo.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(top: 9),
                    child: Text("กำลังเชื่อมต่อกับระบบ PSM @ STAMP", style: TextStyle(fontSize: 20,color: Colors.white)),
                  ),
                ],)
            ),
          ],),
      ),
    );
  }
}
