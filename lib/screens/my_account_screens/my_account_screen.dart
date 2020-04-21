import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/sign_user_out.dart';

class MyAccountScreen extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  MyAccountScreen({Key key, @required this.psmAtStampUser}) : super(key: key);

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  @override
  void initState() {
    logger.d(widget.psmAtStampUser.exportToString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 80),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ListTile(),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            widget.psmAtStampUser.permission ==
                                    PsmAtStampUserPermission.administrator
                                ? Tooltip(
                                    message:
                                        "บัญชีนี้ได้รับการยืนยันจาก PSM @ STAMP ให้เป็น Administrator แล้ว",
                                    textStyle: TextStyle(
                                      fontFamily: "Sukhumwit",
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    child: Icon(
                                      Icons.verified_user,
                                      color: Colors.blue,
                                    ),
                                  )
                                : Container(),
                            widget.psmAtStampUser.permission ==
                                    PsmAtStampUserPermission.staff
                                ? Tooltip(
                                    message:
                                        "บัญชีนี้ได้รับการยืนยันจาก PSM @ STAMP ให้เป็น Staff ฐานกิจกรรมแล้ว",
                                    textStyle: TextStyle(
                                      fontFamily: "Sukhumwit",
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    child: Icon(
                                      Icons.stars,
                                      color: Colors.yellow[600],
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                            ),
                            Text(
                              widget.psmAtStampUser.displayName,
                              style: TextStyle(
                                fontFamily: "Sukhumwit",
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        Text(
                          widget.psmAtStampUser.prefix +
                              widget.psmAtStampUser.name +
                              " " +
                              widget.psmAtStampUser.surname,
                          style: TextStyle(
                            fontFamily: "Sukhumwit",
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          "ม." +
                              widget.psmAtStampUser.year +
                              "/" +
                              widget.psmAtStampUser.room +
                              " " +
                              widget.psmAtStampUser.studentId,
                          style: TextStyle(
                            fontFamily: "Sukhumwit",
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 7,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          width: 140,
                          height: 140,
                          fadeInCurve: Curves.easeIn,
                          placeholder: "assets/images/user.png",
                          image: widget.psmAtStampUser.profileImageUrl,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            signInButtonComponent(
                title: "ออกจากระบบ",
                buttonColor: Colors.redAccent,
                onPressHandler: () {
                  signUserOut(
                    context,
                    psmAtStampUser: widget.psmAtStampUser,
                  );
                })
          ],
        ),
      ),
    );
  }
}
