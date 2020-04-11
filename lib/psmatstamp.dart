import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/icon_data.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_functions/cloud_functions.dart';
import "package:permission_handler/permission_handler.dart";
import 'package:url_launcher/url_launcher.dart';

import 'login.dart';
import 'stamp_book.dart';
import 'staff.dart';
import 'widget.dart';

class PSMATSTAMPMainPage extends StatefulWidget {
  var studentId;
  var prefix;
  var name;
  var surname;
  var year;
  var room;
  var userId;
  var displayName;
  var profileImage;
  var permission;
  var accessToken;
  PSMATSTAMPMainPage(
      {Key key,
      @required this.studentId,
      @required this.prefix,
      @required this.name,
      @required this.surname,
      @required this.year,
      @required this.room,
      @required this.userId,
      @required this.displayName,
      @required this.profileImage,
      @required this.permission,
      @required this.accessToken});

  @override
  _PSMATSTAMPMainPage createState() => _PSMATSTAMPMainPage();
}

class _PSMATSTAMPMainPage extends State<PSMATSTAMPMainPage> {
  void staffpage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Staff(
                  userId: widget.userId,
                  accessToken: widget.accessToken,
                )));
  }

  Future<void> scanQRCode() async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    if (permission != PermissionStatus.granted) {
      print(permission);
      if (permission == PermissionStatus.denied) {
        showMessageBox(
          context,
          true,
          "",
          "",
        );
        try {
          Map<PermissionGroup, PermissionStatus> permissions =
              await PermissionHandler()
                  .requestPermissions([PermissionGroup.camera]);
          Navigator.pop(context);
          if (permission == PermissionStatus.denied) {
            showMessageBox(
              context,
              false,
              "ไม่สามารถเปิดใช้งานกล้องได้",
              "ฟีเจอร์กล้องถูกปิดใช้งานในอุปกรณ์ของคุณ กรุณาตรวจสอบการตั้งค่าหรือการทำงานของกล้อง",
            );
          } else {
            scanQRCode();
          }
        } catch (e) {
          print(e);
          Navigator.pop(context);
          showMessageBox(
            context,
            false,
            "ไม่สามารถเปิดใช้งานกล้องได้",
            "ฟีเจอร์กล้องถูกปิดใช้งานในอุปกรณ์ของคุณ กรุณาตรวจสอบการตั้งค่าหรือการทำงานของกล้อง",
          );
        }
      } else if (permission == PermissionStatus.disabled) {
        showMessageBox(
          context,
          false,
          "ไม่สามารถเปิดใช้งานกล้องได้",
          "ฟีเจอร์กล้องถูกปิดใช้งานในอุปกรณ์ของคุณ กรุณาตรวจสอบการตั้งค่าหรือการทำงานของกล้อง",
        );
      } else if (permission == PermissionStatus.restricted) {
        showMessageBox(
          context,
          false,
          "ไม่สามารถเปิดใช้งานกล้องได้",
          "กรุณาให้สิทธิการเข้าถึงกล้องเพื่อใช้แสกน QR Code ในระบบ PSM @ STAMP",
        );
        bool isOpened = await PermissionHandler().openAppSettings();
      } else {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.camera]);
        scanQRCode();
      }
    } else {
      try {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            "#ebb434", "กลับ", true, ScanMode.QR);
        print(barcodeScanRes);
        if (barcodeScanRes == "-1") {
          print("Back");
        } else {
          showMessageBox(
            context,
            true,
            "",
            "",
          );
          final HttpsCallable callable =
              CloudFunctions.instance.getHttpsCallable(
            functionName: 'QRCodeValidate',
          );
          dynamic resp = await callable.call(<String, dynamic>{
            'qrcodedata': barcodeScanRes,
            'userId': widget.userId,
            'studentId': widget.studentId,
            'accessToken': widget.accessToken
          });
          print(resp.data);
          if (resp.data != "RESTRICT") {
            Navigator.pop(context);
            showMessageBox(
              context,
              false,
              "ผลลัพท์การแสกน QR Code",
              resp.data,
            );
          } else {
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
            showMessageBox(
              context,
              false,
              "Session นี้หมดอายุแล้ว",
              "อาจเป็นไปได้ว่า คุณได้ทำการเข้าสู่ระบบจากอุปกรณ์เครื่องอื่น คุณจะถูกบังคับให้ออกจากระบบในอุปกรณ์เครื่องนี้ทันที",
            );
          }
        }
      } catch (e) {
        print(e);
        Navigator.pop(context);
        showMessageBox(
          context,
          false,
          "เกิดข้อผิดพลาด",
          "ไม่สามารถตรวจสอบ QR Code ได้ กรุณาตรวจ��อบการอนุญติการใช้ก��อง และ การเชื่อมตออินเตอร์เน็ต",
        );
      }
    }
  }

  Future<void> logout() async {
    showMessageBox(context, true, "", "");
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool("isAppleLogin") == false) {
        await LineSDK.channel.invokeMethod("logout");
      } else {
        prefs.setString("PermanentaccessToken", null);
      }

      Firestore.instance
          .collection("Stamp_User")
          .document(widget.userId)
          .updateData({
        "accessToken": "",
      });
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
      showMessageBox(
        context,
        false,
        "ออกจากระบบเรียบร้อยแล้ว",
        "ทำการลงชื่ออกจากระบบเรียบร้อยแล้ว",
      );
    } catch (e) {
      print(e);
      Navigator.pop(context);
      showMessageBox(
        context,
        false,
        "เกิดข้อผิดพลาด",
        "ไม่สามารถออกจากระบบได้ กรุณาลองใหม่อีกครั้ง",
      );
    }
  }

  List<Category> categories = [
    Category(0, "Loading...", icon: IconDataSolid(0xf029)),
  ];

  List categories_firestore = [];

  @override
  void initState() {
    super.initState();
    Firestore.instance.collection("Categories").getDocuments().then(
      (documentSnapshort) {
        var icon;
        categories = [];
        categories_firestore = [];
        var count = 0;
        documentSnapshort.documents.forEach((doc) => {
              if (doc.data["icon"] != null)
                {
                  icon = IconDataSolid(int.parse(doc.data['icon'])),
                }
              else
                {
                  icon = IconDataSolid(0xf029),
                },
              categories.add(
                Category(count, doc.documentID, icon: icon),
              ),
              categories_firestore.add(doc.documentID),
              count += 1,
            });
        setState(
          () {
            _buildCategoryItem;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'แสกน QR Code',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: Icon(Icons.camera_alt),
        backgroundColor: Colors.pink,
        onPressed: () {
          scanQRCode();
        },
      ),
      body: Container(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black87,
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.book)),
                  Tab(
                    icon: Icon(Icons.settings),
                  ),
                ],
              ),
              title: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Image.asset(
                      "assets/image/full_logo.png",
                      height: 80,
                      width: 80,
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: [
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
                  child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 30),
                            child: Text(
                              "กรุณาเลือกกลุ่มสาระการเรียนรู้ เพื่อดูแสตมป์",
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16.0),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0),
                          delegate: SliverChildBuilderDelegate(
                            _buildCategoryItem,
                            childCount: categories.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.redAccent,
                        Colors.blue,
                        Colors.yellow,
                      ],
                    ),
                  ),
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                      borderRadius:
                                          new BorderRadius.circular(10),
                                      child: Image.network(
                                        widget.profileImage,
                                        height: 100,
                                        width: 100,
                                      )),
                                ),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          widget.displayName,
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(
                                            widget.prefix +
                                                widget.name +
                                                " " +
                                                widget.surname,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Text(
                                          "รหัสนักเรียน " +
                                              widget.studentId +
                                              " ม." +
                                              widget.year +
                                              "/" +
                                              widget.room,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                      if (widget.permission == "staff")
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.pink,
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                "[Staff] เข้าสู่ระบบแจกแสตมป์",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              staffpage();
                            },
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Color.fromRGBO(0, 185, 0, 1),
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "น้องแสตมป์",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () async {
                            print("Opening Nong stamp LINE");
                            if (await canLaunch("https://lin.ee/cWz2Ula")) {
                              await launch("https://lin.ee/cWz2Ula");
                            } else {
                              showMessageBox(
                                context,
                                false,
                                "ไม่สามารถเปิด URL ได้",
                                "ไม่สามารถเปิด URL ไปที่ LINE น้องแสตมป์ ได้ ลองใหม่อีกครั้งหรือเพิ่มเพื่อนด้วยการพิมพ์ ID: @nongstamp (มี @ ด้วยครับ)",
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.yellowAccent,
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "ออกจากระบบ",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () {
                            logout();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _categoryPressed(context, category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.black87,
      textColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (category.icon != null) Icon(category.icon),
          if (category.icon != null) SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  _categoryPressed(BuildContext context, Category category) {
    if (category.name != "Loading...") {
      var catid = categories_firestore[category.id];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StampBook(
              userId: widget.userId, categoriesid: catid, icon: category.icon),
        ),
      );
    }
  }
}

class Category {
  final int id;
  final String name;
  final dynamic icon;
  Category(this.id, this.name, {this.icon});
}
