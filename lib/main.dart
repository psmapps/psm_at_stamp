import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//Import Other Page
import 'userlogin.dart';
import 'psmatstamp.dart';
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void  sendNotification(title, message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('10000',
        'FLUTTER_NOTIFICATION_CHANNEL', 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
 
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
 
    await flutterLocalNotificationsPlugin.show(111, title,
        message, platformChannelSpecifics,
        payload: message);
}


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  
      firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          Map mapNotification = message["notification"];
          String title = mapNotification["title"];
          String body = mapNotification["body"];
          sendNotification(title, body);
          
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          Map mapNotification = message["notification"];
          String title = mapNotification["title"];
          String body = mapNotification["body"];
          sendNotification(title, body);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          Map mapNotification = message["notification"];
          String title = mapNotification["title"];
          String body = mapNotification["body"];
          sendNotification(title, body);
        },
       

    );
 
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
 
    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Token : $token");
    });
  runApp(PSMATSTAMP());
}

class PSMATSTAMP extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
    print("Checking Connection");
    //print("AccessToken> " + await getAccessToken());
    try{
      final result = await InternetAddress.lookup("google.com").timeout(Duration(seconds: 10));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        prefs.setString("Mode", "Online");
        print("Internet> Connected");
        bool loginStatus = prefs.getBool("Status");
        if (loginStatus == false || loginStatus == null){
          print("LoginStatus> Not logged in Sending user to loginpage");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else if (loginStatus == true) {
          print("LoginStatus> Logged in");
          var userId = prefs.getString("userId");
          var accessToken = "";
          if (prefs.getBool("isAppleLogin") == true){
            accessToken = prefs.getString("PermanentaccessToken");
          } else {
            accessToken = await getAccessToken();
          }
         
          Firestore.instance.collection("Stamp_User").document(userId).get().then((doc) {
            if (!doc.exists){
                print("Deletd");
                prefs.setBool("Status", false);
                prefs.setString("prefix", null);
                prefs.setString("name", null);
                prefs.setString("surname", null);
                prefs.setString("studentId", null);
                prefs.setString("userId", null);
                prefs.setString("year", null);
                prefs.setString("room", null);
                prefs.setString("displayName", null);
                prefs.setString("profileImage", null);
                prefs.setString("permission", null);
                prefs.setString("accessToken", null);
                
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                showMessageBox("ไม่พบบัญชีของคุณ", "บัญชีของคุณอาจถุกระงับ หรือ ถูกลบ กรุณาติดต่อ PSM @ STAMP Support Team หากมีปัญหาในการใช้งาน ขณะนี้คุณได้ออกจากระบบแล้ว");
            } else {
             var remoteaccessToken = doc.data["accessToken"];
             if (remoteaccessToken != accessToken){
                print("Invalid accessTokn");
                prefs.setBool("Status", false);
                prefs.setString("prefix", null);
                prefs.setString("name", null);
                prefs.setString("surname", null);
                prefs.setString("studentId", null);
                prefs.setString("userId", null);
                prefs.setString("year", null);
                prefs.setString("room", null);
                prefs.setString("displayName", null);
                prefs.setString("profileImage", null);
                prefs.setString("permission", null);
                prefs.setString("accessToken", null);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                showMessageBox("Session นี้หมดอายุแล้ว", "อาจเป็นเพราะ บัญชีนี้มีการเข้าสู่ระบบจากอุปกรณ์อื่น คุณจะถูกบังคับออกจากระบบในอุปกรณ์เครื่องนี้โดยอัตโนมัติ");
             } else {
               print("Success");
               var studentId = doc.data["studentId"];
               var prefix = doc.data['prefix'];
               var name = doc.data['name'];
               var surname = doc.data['surname'];
               var year = doc.data['year'];
               var room = doc.data['room'];
               var displayName = doc.data['displayName'];
               var profileImage = doc.data['profileImage'];
               var permission = doc.data['permission'];
               prefs.setBool("Status", true);
                prefs.setString("prefix", prefix);
                prefs.setString("name", name);
                prefs.setString("surname", surname);
                prefs.setString("studentId", studentId);
                prefs.setString("userId", userId);
                prefs.setString("year", year);
                prefs.setString("room", room);
                prefs.setString("displayName", displayName);
                prefs.setString("profileImage", profileImage);
                prefs.setString("permission", permission);
                prefs.setString("accessToken", accessToken);
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PSMATSTAMPMainPage(userId: userId, studentId: studentId, prefix: prefix, name: name, surname: surname,year: year, room: room, displayName: displayName, profileImage: profileImage, permission: permission, accessToken: accessToken,)));
             }
            }
          });
          
        }
      }
    } on SocketException catch (e) {
      prefs.setString("Mode", "Offline");
      print(e.message);
      print("Internet> Not connected!");
      bool loginStatus = prefs.getBool("Status");
      if (loginStatus == false || loginStatus == null){
        print("LoginStatus> Not logged in Sending user to loginpage");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        
        var prefix = prefs.getString("prefix");
        var name = prefs.getString("name");
        var surname = prefs.getString("surname");
        var studentId = prefs.getString("studentId");
        var userId =  prefs.getString("userId");
        var year =  prefs.getString("year");
        var room =  prefs.getString("room");
        var displayName =  prefs.getString("displayName");
        var profileImage = prefs.getString("profileImage");
        var permission = prefs.getString("permission");
        var accessToken =  prefs.getString("accessToken");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PSMATSTAMPMainPage(userId: userId, studentId: studentId, prefix: prefix, name: name, surname: surname,year: year, room: room, displayName: displayName, profileImage: profileImage, permission: permission, accessToken: accessToken,)));
        showMessageBox("เข้าสู่โหมด Offline", "ข้อมูลที่นำมาแสดง จะเป็นข้อมูลล่าสุดที่ระบบสามารถติดต่อกับ PSM @ STAMP Server ได้ กรุณาเชื่อมต่ออินเตอร์เน็ตเพื่อรับข้อมูลล่าสุด และ คุณจะไม่สามารถแสกน QR Code เพื่อรับแสตมป์ได้ในโหมด Offline");
      }
     
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
              child: Text("ปิด"),
              onPressed: () {
                Navigator.pop(context);
              },)
          ],
        );
      }
    );
  }

  void startNotification(){
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
 
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
      print("onDidReceiveLocalNotification called.");
    });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
 
    flutterLocalNotificationsPlugin.initialize(initializationSettings,);
  }



  void initLineSDK() {
    LineSDK.instance.setup("1588292412").then((_){
        print("LINESDK is prepared");
    });
  }

  @override
  void initState(){
    super.initState();
    initLineSDK();
    startNotification();
    startUserChecking();
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
