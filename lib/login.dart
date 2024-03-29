import 'dart:io';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:psm_at_stamp/createuser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'psmatstamp.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  void signinWithApple() async {
    showMessageBox(
      context,
      true,
      "",
      "",
    );
    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var version = iosInfo.systemVersion;
      if (version.contains('13') == true) {
        final AuthorizationResult result = await AppleSignIn.performRequests([
          AppleIdRequest(requestedScopes: [
            Scope.email,
            Scope.fullName,
          ])
        ]);
        switch (result.status) {
          case AuthorizationStatus.authorized:
            print("successfull sign in");
            final AppleIdCredential appleIdCredential = result.credential;

            OAuthProvider oAuthProvider =
                new OAuthProvider(providerId: "apple.com");
            final AuthCredential credential = oAuthProvider.getCredential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken:
                  String.fromCharCodes(appleIdCredential.authorizationCode),
            );

            final AuthResult _res =
                await FirebaseAuth.instance.signInWithCredential(credential);
            FirebaseAuth.instance.currentUser().then(
              (val) async {
                print(val.uid);
                await Firestore.instance
                    .collection("Stamp_User")
                    .document(val.uid)
                    .get()
                    .then(
                  (valfire) async {
                    String accessToken = new String.fromCharCodes(
                        appleIdCredential.authorizationCode);
                    if (valfire.exists) {
                      var userId = valfire.data['userId'];
                      var studentId = valfire.data['studentId'];
                      var prefix = valfire.data['prefix'];
                      var name = valfire.data['name'];
                      var surname = valfire.data['surname'];
                      var displayName = valfire.data['displayName'];
                      var profileImage = valfire.data['profileImage'];
                      var year = valfire.data['year'];
                      var room = valfire.data['room'];
                      var permission = valfire.data['permission'];
                      var remoteaccessToken = valfire.data['accessToken'];
                      print(studentId);
                      print(prefix + name + " " + surname);
                      print(year + "/" + room);
                      print(displayName);
                      print(profileImage);
                      print(userId);
                      print(permission);
                      print(remoteaccessToken);
                      await Firestore.instance
                          .collection("Stamp_User")
                          .document(userId)
                          .updateData({
                        "accessToken": accessToken,
                      });
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
                      prefs.setString("PermanentaccessToken", accessToken);
                      prefs.setBool("isAppleLogin", true);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PSMATSTAMPMainPage(
                            userId: userId,
                            studentId: studentId,
                            prefix: prefix,
                            name: name,
                            surname: surname,
                            year: year,
                            room: room,
                            displayName: displayName,
                            profileImage: profileImage,
                            permission: permission,
                            accessToken: accessToken,
                          ),
                        ),
                      );
                      if (remoteaccessToken != accessToken &&
                          remoteaccessToken != "") {
                        showMessageBox(context, false, "การเข้าสู่ระบบซ้ำ",
                            "คุณมีการเข้าสู่ระบบจากอุปกรณ์อื่น อุปกรณ์เครื่องเก่าจะไม่สามารถใช้รับแสตมป์ได้ และจะถูกบังคับออกจากระบบโดยอัตโนมัติ");
                      }
                    } else {
                      print("Stamp_User> Not Exisit, Send to create page");
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => createUser(
                            displayName: "(Sign in with Apple)",
                            userId: val.uid,
                            profileImage:
                                "https://firebasestorage.googleapis.com/v0/b/satitprasarnmit-psm-at-stamp.appspot.com/o/user.png?alt=media&token=eb023a2a-0d9e-46f2-8301-ef4e0e20cfee",
                            accessToken: accessToken,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );

            break;
          case AuthorizationStatus.cancelled:
            Navigator.pop(context);
            showMessageBox(
              context,
              false,
              "คุณยกเลิกการเข้าสู่ระบบ",
              "เมื่อสักครู่คุณกดยกเลิกการเข้าสู่ระบบ กรุณาเข้าสู่ระบบใหม่อีกครั้ง",
            );

            break;
          case AuthorizationStatus.error:
            print(result.error);
            Navigator.pop(context);
            showMessageBox(
              context,
              false,
              "เกิดข้อผิดพลาด",
              "เกิดข้อผิดพลาดขณะเข้าสู่ระบบด้วย Apple กรุณาลองใหม่อีกครั้ง",
            );
            break;
        }
      } else {
        Navigator.pop(context);
        showMessageBox(
          context,
          false,
          "เกิดข้อผิดพลาด",
          "อุปกรณ์ของคุณไม่รองรับการเข้าสู่ระบบด้วย Apple (รองรับตั้งเเต่ IOS 13 เป็นต้นมา)",
        );
      }
    }
  }

  void startLineLogin() async {
    showMessageBox(context, true, "", "");
    try {
      final result = await LineSDK.instance.login(scopes: ["profile"]);
      var userId = result.userProfile.userId;
      var displayName = result.userProfile.displayName;
      var profileImage = result.userProfile.pictureUrl;
      var accessToken = await getAccessToken();
      if (accessToken == false) {
        Navigator.pop(context);
        showMessageBox(
          context,
          false,
          "เกิดข้อผิดพลาด",
          "ไม่สามารถเข้าสู่ระบบด้วย LINE ได้ กรุณาลองใหม่อีกครั้ง",
        );
        return;
      }
      printoutput(displayName, userId, profileImage, accessToken);

      checkRegisterwithPSMATSTAMP(
          userId, accessToken, displayName, profileImage);
    } on PlatformException catch (e) {
      print(e);
      Navigator.pop(context);
      switch (e.code.toString()) {
        case "3003":
          // IOS Cancel
          showMessageBox(
            context,
            false,
            "คุณยกเลิกการเข้าสู่ระบบ",
            "เมื่อสักครู่คุณกดยกเลิกการเข้าสู่ระบบ กรุณาเข้าสู่ระบบใหม่อีกครั้ง",
          );
          print("User Cancel the login");
          break;
        case "CANCEL":
          // Android Cancel
          showMessageBox(
            context,
            false,
            "คุณยกเลิกการเข้าสู่ระบบ",
            "เมื่อสักครู่คุณกดยกเลิกการเข้าสู่ระบบ กรุณาเข้าสู่ระบบใหม่อีกครั้ง",
          );
          print("User Cancel the login");
          break;
        case "-1200":
          showMessageBox(
            context,
            false,
            "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต",
            "ไม่สามารถติดต่อกับ LINE ได้ กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ตและลองใหม่อีกครั้ง",
          );
          print("Connection Failed");
          break;
        case "AUTHENTICATION_AGENT_ERROR":
          showMessageBox(
            context,
            false,
            "คุณไม่อนุญาติการเข้าสู่ระบบด้วย LINE",
            "เมื่อสักครู่คุณกดยกเลิกการเข้าสู่ระบบ กรุณาเข้าสู่ระบบใหม่อีกครั้ง",
          );
          print("User decline the login");
          break;
        case "NETWORK_ERROR":
          showMessageBox(
            context,
            false,
            "ไม่สามารถเชื่อมต่อกับ LINE ได้",
            "กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ตและลองใหม่อีกครั้ง",
          );
          print("User decline the login");
          break;
        default:
          showMessageBox(
            context,
            false,
            "เกิดข้อผิดพลาด",
            "เกิดข้อผิดพลาดไม่ทราบสาเหตุ กรุณาเข้าสู่ระบบใหม่อีกครั้ง",
          );
          print("Unknown but failed to login");
          break;
      }
      // showMessageBox(
      //   context,
      //   false,
      //   "เกิดข้อผิดพลาด",
      //   "เกิดข้อผิดพลาดไม่ทราบสาเหตุ กรุณาเข้าสู่ระบบใหม่อีกครั้ง",
      // );
      // print("Unknown but failed to login");
    }
  }

  void checkRegisterwithPSMATSTAMP(String lineUserId, String accessToken,
      String displayName, String profileImage) async {
    var db = Firestore.instance;
    db
        .collection("Stamp_User")
        .document(lineUserId)
        .get()
        .then((snapshot) async {
      if (!snapshot.exists) {
        print("Stamp_User> Not Exisit, Send to create page");
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => createUser(
                      displayName: displayName,
                      userId: lineUserId,
                      profileImage: profileImage,
                      accessToken: accessToken,
                    )));
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
        db.collection("Stamp_User").document(userId).updateData({
          "accessToken": accessToken,
        });
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
        prefs.setBool("isAppleLogin", false);

        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PSMATSTAMPMainPage(
                      userId: userId,
                      studentId: studentId,
                      prefix: prefix,
                      name: name,
                      surname: surname,
                      year: year,
                      room: room,
                      displayName: displayName,
                      profileImage: profileImage,
                      permission: permission,
                      accessToken: accessToken,
                    )));
        if (remoteaccessToken != accessToken && remoteaccessToken != "") {
          showMessageBox(context, false, "การเข้าสู่ระบบซ้ำ",
              "คุณมีการเข้าสู่ระบบจากอุปกรณ์อื่น อุปกรณ์เครื่องเก่าจะไม่สามารถใช้รับแสตมป์ได้ และจะถูกบังคับออกจากระบบโดยอัตโนมัติ");
        }
      }
    });
  }

  void printoutput(String displayName, String userId, String profileImage,
      String accessToken) {
    print("----------------");
    print("displayName> " + displayName);
    print("userId> " + userId);
    print("profileImage> " + profileImage);
    print("accessToken> " + accessToken);
    print("----------------");
  }

  Future getAccessToken() async {
    try {
      final result = await LineSDK.instance.currentAccessToken;
      if (result.value == null) {
        return false;
      } else {
        return result.value;
      }
    } on PlatformException catch (e) {
      print(e.message);
      return false;
    }
  }

  void checkNotification() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.notification);
    print(permission);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler().requestPermissions(
        [PermissionGroup.notification],
      );
    }
  }

  void initState() {
    checkNotification();
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
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/image/full_logo.png'),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    Text("ยินดีต้อนรับเข้าสู่ PSM @ STAMP",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    Text("กรุณาเข้าสู่ระบบก่อนเริ่มใช้งาน",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 0, bottom: 10, right: 10, left: 10),
                              child: RaisedButton(
                                color: Color.fromRGBO(0, 185, 0, 1),
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(1),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/image/line_logo.png',
                                          width: 50,
                                          height: 50,
                                        ),
                                        Container(
                                          color: Colors.black12,
                                          width: 2,
                                          height: 40,
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "เข้าสู่ระบบด้วย LINE",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  startLineLogin();
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, bottom: 20, right: 10),
                      child: AppleSignInButton(
                        style: ButtonStyle.white,
                        type: ButtonType.signIn,
                        onPressed: () {
                          signinWithApple();
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
    );
  }
}
