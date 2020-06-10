import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/stamp_book_services/stamp_categories_constructure.dart';
import 'package:psm_at_stamp/services/stamp_book_services/stamp_details_constructure.dart';

class StampBookComponent extends StatefulWidget {
  final String stampTitle;
  final Function onTapHandler;
  final bool displayStampIndocator;
  final String iconUrl;
  final StampCategories stampCategories;
  final StampIdInfomation stampIdInfomation;
  final PsmAtStampUser psmAtStampUser;
  StampBookComponent({
    Key key,
    @required this.stampTitle,
    this.onTapHandler,
    @required this.displayStampIndocator,
    this.stampIdInfomation,
    this.psmAtStampUser,
    this.stampCategories,
    this.iconUrl,
  }) : super(key: key);

  @override
  _StampBookComponentState createState() => _StampBookComponentState();
}

class _StampBookComponentState extends State<StampBookComponent> {
  StreamSubscription stampInTransactionAmountStream;
  StreamSubscription stampAmountStrean;
  StreamSubscription stampBadgeStream;
  String stampInTransactionAmount = "-";
  String stampAmount = "-";
  bool stampBadge = false;
  @override
  void initState() {
    super.initState();
    widget.displayStampIndocator ? streamStampAmount() : DoNothingAction();
    widget.displayStampIndocator
        ? streamStampInTransactionAmount()
        : DoNothingAction();
    !widget.displayStampIndocator ? streamSetStampBadge() : DoNothingAction();
  }

  @override
  void dispose() {
    widget.displayStampIndocator
        ? stampInTransactionAmountStream.cancel()
        : DoNothingAction();
    widget.displayStampIndocator
        ? stampAmountStrean.cancel()
        : DoNothingAction();
    !widget.displayStampIndocator
        ? stampBadgeStream.cancel()
        : DoNothingAction();
    super.dispose();
  }

  void streamStampInTransactionAmount() {
    stampInTransactionAmountStream = Firestore.instance
        .collection("Stamp_Transaction")
        .where("categories", isEqualTo: widget.stampCategories.categories)
        .where(
          "userId",
          isEqualTo: widget.psmAtStampUser.userId,
        )
        .snapshots()
        .listen((querySnap) {
      setState(() {
        stampInTransactionAmount = querySnap.documents.length.toString();
      });
    });
  }

  void streamStampAmount() {
    stampAmountStrean = Firestore.instance
        .collection("Stamp_Data")
        .where("categories", isEqualTo: widget.stampCategories.categories)
        .snapshots()
        .listen((querySnap) {
      setState(() {
        stampAmount = querySnap.documents.length.toString();
      });
    });
  }

  void streamSetStampBadge() {
    stampBadgeStream = Firestore.instance
        .collection("Stamp_Transaction")
        .where("stampId", isEqualTo: widget.stampIdInfomation.stampId)
        .where("userId", isEqualTo: widget.psmAtStampUser.userId)
        .snapshots()
        .listen((data) {
      if (data.documents.isEmpty) {
        setState(() {
          stampBadge = false;
        });
      } else {
        setState(() {
          stampBadge = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        splashColor: Colors.black38,
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onTapHandler,
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: stampBadge == true ? 0.6 : 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: widget.iconUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: FadeInImage.assetNetwork(
                                imageScale: 10,
                                placeholderScale: 10,
                                fadeInCurve: Curves.decelerate,
                                fadeInDuration: Duration(milliseconds: 375),
                                fadeOutCurve: Curves.decelerate,
                                fadeOutDuration: Duration(milliseconds: 375),
                                placeholder:
                                    "assets/images/icons/icon_gray.png",
                                image: widget.iconUrl,
                              ),
                            )
                          : Image.asset(
                              "assets/images/icons/icon_gray.png",
                              scale: 10,
                            ),
                    ),
                  ),
                  ListTile(
                      title: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          widget.stampTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Sukhumwit",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            stampBadge == true
                ? Container(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset("assets/images/icons/stamp_badge.png"),
                  )
                : Container(),
            widget.displayStampIndocator
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 5, right: 15),
                        child: Text(
                          stampInTransactionAmount + "/" + stampAmount,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Sukhumwit",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
