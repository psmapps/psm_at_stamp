import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
import 'package:psm_at_stamp/components/stamp_creator_component/in_active_component.dart';
import 'package:psm_at_stamp/components/stamp_creator_component/loading_component.dart';
import 'package:psm_at_stamp/components/stamp_creator_component/stamp_timer_component.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/stamp_creator_services/get_stamp_detail_service.dart';
import 'package:psm_at_stamp/services/stamp_creator_services/get_stamp_token_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StampCreatorScreen extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  StampCreatorScreen({Key key, @required this.psmAtStampUser})
      : super(key: key);

  @override
  _StampCreatorScreenState createState() => _StampCreatorScreenState();
}

class _StampCreatorScreenState extends State<StampCreatorScreen> {
  String stampTokenData = "-";
  String stampName = "-";
  String stampCategories = "-";
  String stampIconUrl = "";
  bool isActive = false;
  bool isFailed = false;
  Widget qrCodeSection;

  @override
  void initState() {
    qrCodeSection = stampCreatorLoadingComponent();
    getStampDetail();
    super.initState();
  }

  Future<void> getStampDetail() async {
    Map<String, dynamic> stampDetail;
    try {
      stampDetail = await getStampDetailService(
        context,
        psmAtStampUser: widget.psmAtStampUser,
      );
    } on PlatformException catch (e) {
      logger.e(e);
      setState(() {
        qrCodeSection = inActiveStampCreatorComponent(displayText: e.details);
        isFailed = true;
      });
      return DoNothingAction();
    }
    setState(() {
      stampName = stampDetail["stampName"];
      stampCategories = stampDetail["stampCategories"];
      stampIconUrl = stampDetail["iconUrl"] ?? "";
    });
    try {
      await getStampToken();
    } catch (e) {
      return DoNothingAction();
    }
    setState(() {
      isActive = true;
    });
  }

  Future<void> getStampToken() async {
    String token;
    if (isFailed) {
      throw "ERR";
    }
    try {
      token = await getStampTokenService(
        context,
        psmAtStampUser: widget.psmAtStampUser,
      );
    } on PlatformException catch (e) {
      logger.e(e);
      setState(() {
        qrCodeSection = inActiveStampCreatorComponent(displayText: e.details);
        isActive = false;
        isFailed = true;
      });
      throw "ERR";
    }
    logger.d({
      "token": token,
    });
    setState(() {
      stampTokenData = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              stampIconUrl == ""
                  ? Image.asset(
                      "assets/images/icons/icon_gray.png",
                      scale: 6,
                    )
                  : Center(
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
                            imageScale: 6,
                            placeholderScale: 6,
                            fadeInCurve: Curves.easeIn,
                            placeholder: "assets/images/icons/icon_gray.png",
                            image: stampIconUrl,
                          ),
                        ),
                      ),
                    ),
              Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      "แสตมป์ฐานกิจกรรม",
                      style: TextStyle(
                        fontFamily: "Sukhumwit",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                    ),
                    Text(
                      stampName,
                      style: TextStyle(
                        fontFamily: "Sukhumwit",
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.amber[600],
                      ),
                    ),
                    Text(
                      "กลุ่มสาระ: " + stampCategories,
                      style: TextStyle(
                        fontFamily: "Sukhumwit",
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              isActive
                  ? Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: InkWell(
                            onTap: () {},
                            child: Tooltip(
                              message: "Stamp",
                              child: QrImage(
                                size: 200,
                                version: QrVersions.auto,
                                embeddedImage: AssetImage(
                                  "assets/images/icons/icon_black.png",
                                ),
                                data: json.encode(
                                  {
                                    "type": "stamp",
                                    "token": stampTokenData,
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        StampTimerComponent(
                          timerTriggeredCallback: () {
                            getStampToken();
                          },
                          isActive: isActive,
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: <Widget>[
                          qrCodeSection,
                        ],
                      ),
                    ),
              isFailed
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: signInButtonComponent(
                        title: "กดที่นี่ เพื่อลองเชื่อมต่อใหม่อีกครั้ง",
                        buttonColor: Colors.yellow,
                        icon: FontAwesomeIcons.syncAlt,
                        onPressHandler: () {
                          setState(() {
                            qrCodeSection = stampCreatorLoadingComponent();
                            isFailed = false;
                            isActive = false;
                          });
                          getStampDetail();
                        },
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
