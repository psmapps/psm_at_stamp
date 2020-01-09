import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'confirmuser.dart';
import 'widget.dart';

class createUser extends StatefulWidget {
  var displayName;
  var profileImage;
  var accessToken;
  var userId;

  createUser(
      {Key key,
      @required this.userId,
      @required this.displayName,
      @required this.profileImage,
      @required this.accessToken})
      : super(key: key);

  @override
  CreateUserState createState() => CreateUserState();
}

class CreateUserState extends State<createUser> {
  @override
  Widget build(BuildContext context) {
    TextEditingController studentIdText = new TextEditingController();
    void checkStudentID({studentIdPassed}) {
      showMessageBox(context, true, "", "");
      var studentId = "";
      studentId = studentIdText.text;
      print("StudentID> " + studentId);
      if (studentId == "" || studentId.length < 6) {
        Navigator.pop(context);
        showMessageBox(context, false, "กรุณากรอกข้อมูลให้ครบก่อนทำการผูกบัญชี",
            "กรุณากรอกรหัสนักเรียนให้ถูกต้องก่อนทำการผูกบัญชี PSM @ STAMP");
      } else {
        Firestore.instance
            .collection("Student_Data")
            .document(studentId)
            .get()
            .then(
          (snapShot) {
            if (!snapShot.exists) {
              Navigator.pop(context);
              showMessageBox(
                  context,
                  false,
                  "ไม่พบรหัสนักเรียนที่คุณระบุมา",
                  "ไม่พบรหัสนักเรียนนี้ (" +
                      studentId +
                      ") กรุณาตรวจสอบและลองใหม่อีกครั้ง");
            } else {
              if (snapShot.data['isRegistered']) {
                print("Registation> Registered");
                Navigator.pop(context);
                showMessageBox(
                    context,
                    false,
                    "รหัสนักเรียนนี้ถูกใช้ลงทะเบียนไปแล้ว",
                    "รหัสนักเรียนนี้ถูกผูกบัญชีไปแล้ว จึงไม่สามารถผูกซ้ำอีกครั้งได้ หากมีปัญหาในการผูกบัญชี กรุณาติดต่อ PSM @ STAMP Team เพื่อแก้ไขปัญหาต่อไป");
              } else {
                print("Registation> Not Registered");
                var prefix = snapShot.data['prefix'];
                var name = snapShot.data['name'];
                var surname = snapShot.data['surname'];
                var year = snapShot.data['year'];
                var room = snapShot.data['room'];
                Navigator.pop(context);
                print("----{User Data}----");
                print(prefix + name + " " + surname);
                print("M." + year + "/" + room);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmPage(
                      studentId: studentId,
                      prefix: prefix,
                      name: name,
                      surname: surname,
                      year: year,
                      room: room,
                      displayName: widget.displayName,
                      userId: widget.userId,
                      profileImage: widget.profileImage,
                      accessToken: widget.accessToken,
                    ),
                  ),
                );
              }
            }
          },
        );
      }
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 43, 43, 1),
      appBar: AppBar(
        title: Text("ผูกบัญชี PSM @ STAMP"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Image.asset(
                      "assets/image/full_logo.png",
                      width: 200,
                      height: 200,
                    ),
                  )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text("ผูกบัญชี PSM @ STAMP",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    Text("(ทำเพียงครั้งแรกครั้งเดียว)",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "ข้อตกลงก่อนการผูกบัญชี:",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.double),
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Text(
                            "1. คุณยืนยันว่าคุณคือเจ้าของรหัสนักเรียนที่คุณกรอกด้านล่างจริง",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                        Text(
                            "2. เมื่อคุณผูกบัญชีไปเเล้ว Apple ID, LINE ID และ ร��สนักเรียนนี้ จะไม่สามารถผูกบัญชีได้ใหม่อีกครั้ง",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                        Text(
                            "3. (หากผูกบัญชีกับ LINE) คุณสามารถเข้าใช้งาน น้องแสตมป์ ใน LNE ได้โดยไม่ต้องลงทะเบียนใหม่อีกครั้ง",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                        Text(
                          "4. (หากผูกบัญชีกับ Apple) คุณต้องลงทะเบียนกับน้องแสตมป์ด้วยตนเองหากต้องการร่วมกิจกรรมจาก PSM @ STAMP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                style: TextStyle(color: Colors.white, fontSize: 25),
                cursorColor: Colors.white,
                controller: studentIdText,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'รหัสนักเรียน เช่น (018693)',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(245, 168, 44, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                onChanged: (changedText) {
                  if (changedText.length > 6) {
                    var newText =
                        changedText.substring(0, changedText.length - 1);
                    studentIdText.text = newText;
                    studentIdText.selection =
                        TextSelection.collapsed(offset: 6);
                  }
                },
                onFieldSubmitted: (studentId) {
                  checkStudentID(studentIdPassed: studentId);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                margin: const EdgeInsets.only(
                    top: 0, bottom: 10, right: 10, left: 10),
                child: RaisedButton(
                  color: Color.fromRGBO(217, 160, 2, 1),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          "ผูกบัญชี PSM @ STAMP",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    var studentId = studentIdText.text;
                    checkStudentID(studentIdPassed: studentId);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
              child: Container(
                margin: const EdgeInsets.only(
                    top: 0, bottom: 10, right: 10, left: 10),
                child: RaisedButton(
                  color: Colors.grey,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Column(children: <Widget>[
                    Center(
                        child: Text("ติดต่อ PSM @ STAMP Support Team",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))),
                  ]),
                  onPressed: () async {
                    showMessageBox(context, true, "", "");
                    print("Opening PSM @ STAMP LINE");
                    if (await canLaunch("https://lin.ee/hj7O6Fn")) {
                      Navigator.pop(context);
                      await launch("https://lin.ee/hj7O6Fn");
                    } else {
                      Navigator.pop(context);
                      showMessageBox(context, false, "ไม่สามารถเปิด URL ได้",
                          "ไม่สามารถเปิด URL ไปที่ LINE PSM @ STAMP ได้ ลองใหม่อีกครั้งหรือเพิ่มเพื่อนด้วยการพิมพ์ ID: @psmatstamp (มี @ ด้วยครับ)");
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
