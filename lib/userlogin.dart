import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

class LoginPage extends StatefulWidget{

@override
_LoginPage createState() => _LoginPage();
}


class _LoginPage extends State<LoginPage>{


  void startLineLogin() async{
    try {
    final result = await LineSDK.instance.login(scopes: ["profile"]);
      print(result.toString());
      showMessageBox(false, "เข้าสู่ระบบสำเร็จ", "สำเร็จ " + result.userProfile.displayName);
    } on PlatformException catch (e) {
      print(e.toString());
      showMessageBox(false, "เกิดข้อผิดพลาด", e.toString());
    }
  }

  void showMessageBox(bool showIndicator,String title, String message) async{
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
        if (showIndicator == true){
          return AlertDialog(
          title: Text(title),
          content: Row(
            children: <Widget>[
            Center(child:CircularProgressIndicator()),
          ],),
          actions: <Widget>[
            FlatButton(
              child: Text("ปิด"),
              onPressed: () {
                Navigator.pop(context);
              },)
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