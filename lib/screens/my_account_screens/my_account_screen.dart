import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/my_account_component/badge_display_component.dart';
import 'package:psm_at_stamp/components/my_account_component/display_name_component.dart';
import 'package:psm_at_stamp/components/my_account_component/stamp_in_transaction_amount_component.dart';
import 'package:psm_at_stamp/components/notification_components/message_box.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
import 'package:psm_at_stamp/screens/setting_screens/setting_screen.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/sign_user_out.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyAccountScreen extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  MyAccountScreen({Key key, @required this.psmAtStampUser}) : super(key: key);

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  @override
  void initState() {
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
                        badgeDisplayComponent(
                          signInServices: widget.psmAtStampUser.signInServices,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            badgeDisplayComponent(
                              psmAtStampUserPermission:
                                  widget.psmAtStampUser.permission,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                            ),
                            displayNameComponent(
                              displayName: widget.psmAtStampUser.displayName,
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
                              " - " +
                              widget.psmAtStampUser.studentId,
                          style: TextStyle(
                            fontFamily: "Sukhumwit",
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        widget.psmAtStampUser.permission !=
                                PsmAtStampUserPermission.staff
                            ? StampInTransactionAmountComponent(
                                psmAtStampUser: widget.psmAtStampUser,
                              )
                            : Container(),
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: InkWell(
                            onTap: () {},
                            child: Tooltip(
                              message: widget.psmAtStampUser.userId,
                              child: QrImage(
                                size: 150,
                                version: QrVersions.auto,
                                embeddedImage: AssetImage(
                                  "assets/images/icons/icon_curve_black.png",
                                ),
                                data: json.encode({
                                  "type": "user",
                                  "userId": widget.psmAtStampUser.userId,
                                }),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Center(
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
              ],
            ),
            signInButtonComponent(
              icon: FontAwesomeIcons.cog,
              title: "ตั้งค่า",
              buttonColor: Colors.grey,
              onPressHandler: () {
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingScreen(
                      psmAtStampUser: widget.psmAtStampUser,
                    ),
                  ),
                );
              },
            ),
            signInButtonComponent(
              title: "ออกจากระบบ",
              icon: FontAwesomeIcons.signOutAlt,
              buttonColor: Colors.redAccent,
              onPressHandler: () {
                return showMessageBox(
                  context,
                  title: "ออกจากระบบ",
                  content: "คุณต้องการออกจากระบบใช่หรือไม่?",
                  icon: FontAwesomeIcons.exclamationTriangle,
                  iconColor: Colors.yellow,
                  actionsButton: [
                    IconButton(
                      icon: Icon(FontAwesomeIcons.timesCircle),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.checkCircle),
                      color: Colors.redAccent,
                      onPressed: () {
                        Navigator.pop(context);
                        signUserOut(
                          context,
                          psmAtStampUser: widget.psmAtStampUser,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
            ),
          ],
        ),
      ),
    );
  }
}
