import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

//Import Other Page
import 'userlogin.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
      runApp(PSMATSTAMP());
  });
}

class PSMATSTAMP extends StatelessWidget {

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
    final prefs = await SharedPreferences.getInstance();
    //print("AccessToken> " + await getAccessToken());
    try{
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        prefs.setString("Mode", "Online");
        print("Internet> Connected");
        bool loginStatus = prefs.getBool("Status");
        if (loginStatus == false || loginStatus == null){
          print("LoginStatus> Not logged in Sending user to loginpage");
          await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          var accessToken = await getAccessToken();
          //TODO: Push to MainPage
        }
      }
    } on SocketException catch (e) {
      prefs.setString("Mode", "Offline");
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
          content: Wrap(children: <Widget>[Text(message)],),
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
                    child: Wrap(
                      children: <Widget>[
                        Text("กำลังเชื่อมต่อกับระบบ PSM @ STAMP", style: TextStyle(fontSize: 20,color: Colors.white)),
                      ],
                    ),
                  ),
                ],)
            ),
          ],),
      ),
    );
  }
}
