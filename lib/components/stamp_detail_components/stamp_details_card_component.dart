import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psm_at_stamp/components/stamp_distributing_component/in_active_component.dart';
import 'package:psm_at_stamp/components/stamp_detail_components/on_active_stamp_detail_info_component.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/stamp_book_services/stamp_details_constructure.dart';

class StampDetailCardComponent extends StatefulWidget {
  final StampIdInfomation stampIdInfomation;
  final PsmAtStampUser psmAtStampUser;
  StampDetailCardComponent({
    Key key,
    @required this.stampIdInfomation,
    @required this.psmAtStampUser,
  }) : super(key: key);

  @override
  _StampDetailCardComponentState createState() =>
      _StampDetailCardComponentState();
}

class _StampDetailCardComponentState extends State<StampDetailCardComponent> {
  StreamSubscription stampInfomationStream;
  StreamSubscription stampInTransactionStream;
  Widget stampDetailWidget = Center(
    child: CircularProgressIndicator(),
  );
  String iconUrl;
  String name;
  String location;
  String details;
  bool isStamped = false;
  StampStatus isOpen;

  @override
  void initState() {
    streamStampInformation();
    if (widget.stampIdInfomation.displayStampBadge) {
      streamStampInTransaction();
    }

    super.initState();
  }

  @override
  void dispose() {
    try {
      stampInfomationStream.cancel();
      stampInTransactionStream.cancel();
    } on NoSuchMethodError catch (_) {
      DoNothingAction();
    } catch (e) {
      logger.d(e);
    }
    super.dispose();
  }

  Future<void> iconUrlFromCategories({@required String categories}) async {
    DocumentSnapshot categoriesDoc;
    try {
      categoriesDoc = await Firestore.instance
          .collection("Categories")
          .document(categories)
          .get()
          .timeout(Duration(seconds: 10));
    } catch (e) {
      logger.e(e);
    }
    if (!categoriesDoc.exists) {
      throw PlatformException(code: "CATEGORES_NOT_FOUND");
    }
    setState(() {
      if (categoriesDoc.data["iconUrl"] != "" &&
          categoriesDoc.data["iconUrl"] != null) {
        iconUrl = categoriesDoc.data["iconUrl"];
      } else {
        iconUrl = "";
      }
    });
  }

  void streamStampInformation() {
    stampInfomationStream = Firestore.instance
        .collection("Stamp_Data")
        .document(widget.stampIdInfomation.stampId)
        .snapshots()
        .listen(
      (doc) async {
        if (!doc.exists) {
          setState(() {
            stampDetailWidget = inActiveStampCreatorComponent(
              displayText: "ไม่พบแสตมป์ที่คุณระบุมา",
            );
          });
        } else {
          setState(
            () {
              if (doc.data["iconUrl"] != null && doc.data["iconUrl"] != "") {
                iconUrl = doc.data["iconUrl"];
              } else {
                if (widget.stampIdInfomation.categoriesIconUrl != "" &&
                    widget.stampIdInfomation.categoriesIconUrl != null) {
                  iconUrl = widget.stampIdInfomation.categoriesIconUrl;
                } else {
                  iconUrlFromCategories(categories: doc.data["categories"]);
                }
              }
              name = doc.data["name"];
              location = doc.data["location"];
              details = doc.data["detail"];
              isOpen =
                  convertStampStatusToEnum(stampStatus: doc.data["isOpen"]);
              stampDetailWidget = onActiveStampDetailInfoComponent(
                name: name,
                location: location,
                details: details,
                isOpen: isOpen,
              );
            },
          );
        }
      },
    );
  }

  void streamStampInTransaction() {
    stampInTransactionStream = Firestore.instance
        .collection("Stamp_Transaction")
        .where("userId", isEqualTo: widget.psmAtStampUser.userId)
        .where(
          "stampId",
          isEqualTo: widget.stampIdInfomation.stampId,
        )
        .snapshots()
        .listen(
      (data) {
        setState(
          () {
            if (data.documents.isNotEmpty) {
              isStamped = true;
            } else {
              isStamped = false;
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 80),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                    ),
                    stampDetailWidget,
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                    ),
                    widget.stampIdInfomation.displayStampBadge
                        ? Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 160,
                              height: 160,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: isStamped
                                      ? Stack(
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/images/stamp_badge.png",
                                            ),
                                          ],
                                        )
                                      : Text(
                                          "สแกน QR Code ที่ฐานกิจกรรมเพื่อรับแสตมป์",
                                          style: TextStyle(
                                            fontFamily: "Sukhumwit",
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
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
                  child: iconUrl != null
                      ? FadeInImage.assetNetwork(
                          imageScale: 7,
                          placeholderScale: 7,
                          fadeInCurve: Curves.decelerate,
                          fadeOutCurve: Curves.decelerate,
                          placeholder: "assets/images/icons/icon_gray.png",
                          image: iconUrl,
                        )
                      : Image.asset(
                          "assets/images/icons/icon_gray.png",
                          scale: 7,
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
