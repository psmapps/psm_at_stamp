import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'userlogin.dart';
import 'widget.dart';

class Staff extends StatefulWidget {
  var userId;
  var accessToken;

  Staff({Key key, @required this.userId, @required this.accessToken});
  @override
  StaffState createState() => StaffState();
}

class StaffState extends State<Staff> {
  Timer timer;
  var stampId = "";
  var stampData = "";
  var stampName = "";
  var categories = "";
  var refreshTxt = "Refresh Stamp";

  void genNewQRCode() async {
    setState(() {
      refreshTxt = "Refreshing. . .";
    });
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'QRGenerate',
    );
    dynamic resp = await callable.call(<String, dynamic>{
      "userId": widget.userId,
      "accessToken": widget.accessToken,
      "stampId": stampId,
      "categories": categories,
    });
    print(resp.data);
    if (resp.data == "404") {
      Navigator.pop(context);
      showMessageBox(context, false, "ไม่พบแสตมปืที่คุณได้สิทธิแจก",
          "กรุณาติดต่อ PSM @ STAMP Team");
    } else if (resp.data == "RESTRECT") {
      final prefs = await SharedPreferences.getInstance();
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
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      showMessageBox(context, false, "Session นี้หมดอายุแล้ว",
          "อาจเป็นไปได้ว่า คุณได้ทำการเข้าสู่ระบบจากอุปกรณ์เครื่องอื่น คุณจะถูกบังคับให้ออกจากระบบในอุปกรณ์เครื่องนี้ทันที");
    } else {
      setState(() {
        refreshTxt = "Refresh Stamp";
        stampData = resp.data;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    Firestore.instance
        .collection("Stamp_Data")
        .where("userId", isEqualTo: widget.userId)
        .getDocuments()
        .then((doc) {
      if (doc.documents.isNotEmpty) {
        doc.documents.forEach((docdata) {
          stampId = docdata.documentID;
          categories = docdata.data['categories'];
          setState(() {
            stampName = docdata.data['name'];
          });
          genNewQRCode();
          timer = Timer.periodic(
              Duration(seconds: 27), (Timer t) => genNewQRCode());
        });
      } else {
        Navigator.pop(context);
        showMessageBox(context, false, "ไม่พบสิทธิการแจกแสตมป์ของคุณ",
            "ไม่พบสิทธิการแจกแสตมป์ของคุณ กรุณาติดต่อ PSM @ STAMP Team เพื่อแก้ไขปัญหาต่อไป");
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("ระบบแจกแสตมป์ (Staff)"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue,
                  Colors.yellow,
                  Colors.redAccent,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Image.asset(
                              "assets/image/full_logo.png",
                              height: 150,
                              width: 150,
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "แสตมป์จากฐานกิจกรรม: " + stampName,
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: QrImage(
                          data: stampData, version: QrVersions.auto, size: 300),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("Note: แสตมป์มีอ���ยุ 30 วินา��",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.pink,
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        refreshTxt,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (refreshTxt != "Refreshing. . .") {
                        setState(() {
                          refreshTxt = "Refreshing. . .";
                        });
                        genNewQRCode();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
