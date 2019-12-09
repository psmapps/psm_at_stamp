import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:psm_at_stamp/createuser.dart';

class LoginPage extends StatefulWidget{

@override
_LoginPage createState() => _LoginPage();
}


class _LoginPage extends State<LoginPage>{



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

  void checkRegisterwithPSMATSTAMP(String lineUserId, String accessToken, String displayName, String profileImage){
      var db = Firestore.instance;
      db.collection("Stamp_User").document(lineUserId).get().then( (snapshot) {
        if (!snapshot.exists) {
          print("Stamp_User> Not Exisit, Send to create page");
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => createUser()));
        } else {
          print("Exisit");
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


  void initState(){

    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
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