import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:psm_at_stamp/createuser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'psmatstamp.dart';


class LoginPage extends StatefulWidget{

@override
_LoginPage createState() => _LoginPage();
}


class _LoginPage extends State<LoginPage>{

TextEditingController loginCode = new TextEditingController();

  void startLineLogin() async{
    showMessageBox(true, "", "");
    try {
    final result = await LineSDK.instance.login(scopes: ["profile"]);
      var userId = result.userProfile.userId;
      var displayName = result.userProfile.displayName;
      var profileImage = result.userProfile.pictureUrl;
      var accessToken = await getAccessToken();
      if (accessToken == false){
        Navigator.pop(context);
        showMessageBox(false, "เกิดข้อผิดพลาด", "ไม่สามารถเข้าสู่ระบบด้วย LINE ได้ กรุณาลองใหม่อีกครั้ง");
        return;
      }
      printoutput(displayName, userId, profileImage, accessToken);
      
      checkRegisterwithPSMATSTAMP(userId, accessToken, displayName, profileImage);

    } on PlatformException catch (e) {
          print(e);
          Navigator.pop(context);
          switch (e.code.toString()){
            case "3003":
                //IOS Cancel
                showMessageBox(false, "คุณยกเลิกการเข้าสู่ระบบ", "เมื่อสักครู่คุณกดยกเลิกการเข้าสู่ระบบ กรุณาเข้าสู่ระบบใหม่อีกครั้ง");
                print("User Cancel the login");
                break;
            case "CANCEL":
                //Android Cancel
                showMessageBox(false, "คุณยกเลิกการเข้าสู่ระบบ", "เมื่อสักครู่คุณกดยกเลิกการเข้าสู่ระบบ กรุณาเข้าสู่ระบบใหม่อีกครั้ง");
                print("User Cancel the login");
                break;
            case "-1200":
                showMessageBox(false, "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต", "ไม่สามารถติดต่อกับ LINE ได้ กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ตและลองใหม่อีกครั้ง");
                print("Connection Failed");
                break;
            case "AUTHENTICATION_AGENT_ERROR":
                showMessageBox(false, "คุณไม่อนุญาติการเข้าสู่ระบบด้วย LINE", "เมื่อสักครู่คุณกดยกเลิกการเข้าสู่ระบบ กรุณาเข้าสู่ระบบใหม่อีกครั้ง");
                print("User decline the login");
                break;
            case "NETWORK_ERROR":
                showMessageBox(false, "ไม่สามารถเชื่อมต่อกับ LINE ได้", "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ตและลองใหม่อีกครั้ง");
                print("User decline the login");
                break;
            default:
                showMessageBox(false, "เกิดข้อผิดพลาด", "เกิดข้อผิดพลาดไม่ทราบสาเหตุ กรุณาเข้าสู่ระบบใหม่อีกครั้ง");
                print("Unknown but failed to login");
                break;
        }
    }
  }

  void checkRegisterwithPSMATSTAMP (String lineUserId, String accessToken, String displayName, String profileImage) async{
      var db = Firestore.instance;
      db.collection("Stamp_User").document(lineUserId).get().then( (snapshot) async {
        if (!snapshot.exists) {
          print("Stamp_User> Not Exisit, Send to create page");
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => createUser(displayName: displayName, userId: lineUserId, profileImage: profileImage, accessToken: accessToken,)));
        } else {
          print("Logged In");
          var userId = snapshot.data['userId'];
          var studentId = snapshot.data['studentId'];
          var prefix = snapshot.data['prefix'];
          var name = snapshot.data['name'];
          var surname = snapshot.data['surname'];
          var displayName = snapshot.data['displayName'];
          var profileImage = snapshot.data['profileImage'];
          var year = snapshot.data['year'];
          var room = snapshot.data['room'];
          var permission = snapshot.data['permission'];
          var remoteaccessToken = snapshot.data['accessToken'];
          print(studentId);
          print(prefix + name + " " + surname);
          print(year + "/" + room);
          print(displayName);
          print(profileImage);
          print(userId);
          print(permission);
          print(remoteaccessToken);
          
          if (remoteaccessToken != accessToken){
            showMessageBox(false, "การเข้าสู่ระบบซ้ำ", "คุณมีการเข้าสู่ระบบจากอุปกรณ์อื่น อุปกรณ์เครื่องเก่าจะไม่สามารถใช้รับแสตมป์ได้ และจะถูกบังคับออกจากระบบโดยอัตโนมัติ");
            db.collection("Stamp_User").document(userId).updateData({
              "accessToken": accessToken,
            });
          }
          final prefs = await SharedPreferences.getInstance();
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

          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PSMATSTAMPMainPage(userId: userId, studentId: studentId, prefix: prefix, name: name, surname: surname,year: year, room: room, displayName: displayName, profileImage: profileImage, permission: permission, accessToken: accessToken,)));
          
        } 
      });
  }

  void printoutput(String displayName, String userId, String profileImage, String accessToken){
      print("----------------");
      print("displayName> " + displayName);
      print("userId> " + userId);
      print("profileImage> " + profileImage);
      print("accessToken> " + accessToken);
      print("----------------");
  }

  Future getAccessToken() async{
    try {
      final result = await LineSDK.instance.currentAccessToken;
      if (result.value == null){
        return false;
      } else {
        return result.value;
      }
    }  on PlatformException catch (e) {
      print(e.message);
      return false;
    }
  }

  void showMessageBox(bool showIndicator,String title, String message) async{
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
        if (showIndicator == true){
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(child: CircularProgressIndicator()),
            ],
          );
        } else {
          return AlertDialog(
          
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("ปิด"),
              onPressed: () {
                Navigator.pop(context);
              },)
           ],
          );
        }
      }
    );
  }

  


  void checkLoginCode() async{
    final prefs = await SharedPreferences.getInstance();
    showMessageBox(true, "", "");
                var logincode = loginCode.text;
                if (logincode != ""){
                  Firestore.instance.collection("loginCode").document(logincode.toString()).get().then((doc) {
                    if (doc.exists){
                      var userId = doc.data['userId'];
                      Firestore.instance.collection("Stamp_User").document(userId).get().then((docdata) {
                        if (docdata.exists){
                          var userId = docdata.data['userId'];
                          var studentId = docdata.data['studentId'];
                          var prefix = docdata.data['prefix'];
                          var name = docdata.data['name'];
                          var surname = docdata.data['surname'];
                          var displayName = docdata.data['displayName'];
                          var profileImage = docdata.data['profileImage'];
                          var year = docdata.data['year'];
                          var room = docdata.data['room'];
                          var permission = docdata.data['permission'];
                          var localaccessToken = "";
                          if (prefs.getString("localaccessToken") == null || prefs.getString("localaccessToken") == ""){
                            const chars = "abcdefghijklmnopqrstuvwxyz0123456789";

                            String RandomString(int strlen) {
                              Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
                              String result = "";
                              for (var i = 0; i < strlen; i++) {
                                result += chars[rnd.nextInt(chars.length)];
                              }
                              return result;
                            }
                            localaccessToken = RandomString(50);
                            prefs.setString("localaccessToken", localaccessToken);
                            Firestore.instance.collection("Stamp_User").document(userId).updateData({
                              "accessToken": localaccessToken,
                              "isLoginCode": true
                            });


                          } else {
                            localaccessToken = prefs.getString("localaccessToken");
                            Firestore.instance.collection("Stamp_User").document(userId).updateData({
                              "accessToken": localaccessToken,
                              "isLoginCode": true
                            });
                          }

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
                          prefs.setString("accessToken", localaccessToken);
                          prefs.setBool("isLoginCode", true);
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PSMATSTAMPMainPage(userId: userId, studentId: studentId, prefix: prefix, name: name, surname: surname,year: year, room: room, displayName: displayName, profileImage: profileImage, permission: permission, accessToken: localaccessToken,)));
                          
                        } else {
                          Navigator.pop(context);
                          showMessageBox(false, "ไม่พบบัญชีที่ผูกกับ loginCode นี้", "ไม่พบบัญชีที่ผูกกับ loginCode นี้ กรุณาติดต่อ PSM @ STAMP Team เพื่อแก้ไขปัญหานี้");
                        }
                      });
                    } else {
                      Navigator.pop(context);
                      showMessageBox(false, "ไม่พบรหัส loginCode นี้", "ไม่พบรหัส loginCode นี้ กรุณากรอกข้อมูลให้ถูกต้องเพื่อเข้าสู่ระบบด้วย loginCode หรือติดต่อ PSM @ STAMP Team");
                    }
                  });
                } else {
                  Navigator.pop(context);
                  showMessageBox(false, "กรุณากรอกรหัส LoginCode", "กรุณากรอกรหัส LoginCode เพื่อทำการเข้าสู่ระบบ");
                }
  }


 void checkloginCode() async{
   
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
       
          return AlertDialog(
          title: Text("กรุณากรอก LoginCode เพื่อทำการเข้าสู่ระบบ"),
          content: TextField(controller: loginCode),
          actions: <Widget>[
            
            FlatButton(
              child: Text("ปิด"),
              onPressed: () {
                Navigator.pop(context);
              },),
              FlatButton(
              child: Text("ตรวจสอบและเข้าสู่ระบบ"),
              onPressed: () {
                Navigator.pop(context);
                checkLoginCode();
              },)
           ],
          );
        
      }
    );
  }


  void initState(){

    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(43, 43, 43, 1),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 50, 70, 0),
                child: Column(children: <Widget>[
                  Image.asset('assets/image/full_logo.png'),
                ],),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                  Text("ยินดีต้อนรับเข้าสู่ PSM @ STAMP", style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold)),
                  Text("กรุณาเข้าสู่ระบบก่อนเริ่มใช้งาน", style: TextStyle(fontSize: 18,color: Colors.white,  fontWeight: FontWeight.bold)),
                ],),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                     Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 0, bottom: 10, right: 10, left: 10),
                                child: RaisedButton(
                                  color: Color.fromRGBO(0, 185, 0, 1),
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(1),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Image.asset('assets/image/line_logo.png', width: 50, height: 50,),
                                          Container(
                                            color: Colors.black12,
                                            width: 2,
                                            height: 40,
                                          ),
                                          Expanded(
                                            child: Center(child: Text("เข้าสู่ระบบด้วย LINE", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),)
                                          ]
                                          )
                                        ],
                                      ),
                                  onPressed: (){
                                    startLineLogin();
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  ),
                                ),
                              ),


                              
                          ]
                          ),
                      ),
                      Row(children: <Widget>[
                        Expanded(child: 
                        Padding(padding: EdgeInsets.fromLTRB(10,0,10 ,20),
                      child: RaisedButton(
                        color: Colors.transparent,
                        textColor: Colors.grey,
                        padding: const EdgeInsets.all(10),
                        child: Text("เข้าสู่ระบบด้วย LoginCode", style: TextStyle(fontSize: 13, color: Colors.white),),
                        onPressed: (){
                          //TODO: LoginWith LoginCode
                          checkloginCode();

                        },
                      ),)
                        ,)
                      ],)
                  ],),
              )
            ],),
        )
        )
    );
  }
}