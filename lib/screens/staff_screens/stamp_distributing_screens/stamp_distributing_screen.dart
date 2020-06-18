import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/button_components/app_button_components.dart';
import 'package:psm_at_stamp/components/stamp_distributing_component/in_active_component.dart';
import 'package:psm_at_stamp/components/stamp_distributing_component/loading_component.dart';
import 'package:psm_at_stamp/components/stamp_distributing_component/manual_distributing.dart';
import 'package:psm_at_stamp/components/stamp_distributing_component/qr_code_distributing.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/stamp_distributing_services/get_stamp_detail_service.dart';
import 'package:psm_at_stamp/services/stamp_distributing_services/get_stamp_token_service.dart';

enum DistributingType { qrCode, manual }

class StampDistributingScreen extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  final DistributingType distributingType;
  StampDistributingScreen({
    Key key,
    @required this.psmAtStampUser,
    @required this.distributingType,
  }) : super(key: key);

  @override
  _StampDistributingScreenState createState() =>
      _StampDistributingScreenState();
}

class _StampDistributingScreenState extends State<StampDistributingScreen> {
  String stampTokenData = "-";
  String stampName = "-";
  String stampCategories = "-";
  String stampIconUrl = "";
  bool isActive = false;
  bool isFailed = false;
  Widget distributingSection;

  @override
  void initState() {
    distributingSection = stampCreatorLoadingComponent();
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
        isFailed = true;
        distributingSection =
            inActiveStampCreatorComponent(displayText: e.details);
      });
      return DoNothingAction();
    }
    setState(() {
      stampName = stampDetail["stampName"];
      stampCategories = stampDetail["stampCategories"];
      stampIconUrl = stampDetail["iconUrl"] ?? "";
    });
    if (widget.distributingType == DistributingType.qrCode) {
      try {
        await getStampToken();
      } catch (e) {
        return DoNothingAction();
      }
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
        distributingSection =
            inActiveStampCreatorComponent(displayText: e.details);
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
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
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
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.amber[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "กลุ่มสาระ: " + stampCategories,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              isActive
                  ? widget.distributingType == DistributingType.qrCode
                      ? qrCodeDistributing(
                          stampTokenData: stampTokenData,
                          isActive: isActive,
                          timeTriggerCallback: () {
                            getStampToken();
                          },
                        )
                      : ManualDistributing(
                          psmAtStampUser: widget.psmAtStampUser,
                        )
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: <Widget>[
                          distributingSection,
                        ],
                      ),
                    ),
              isFailed
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: appButtonComponent(
                        title: "กดที่นี่ เพื่อลองเชื่อมต่อใหม่อีกครั้ง",
                        buttonColor: Colors.yellow,
                        icon: FontAwesomeIcons.syncAlt,
                        onPressHandler: () {
                          setState(() {
                            distributingSection =
                                stampCreatorLoadingComponent();
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
