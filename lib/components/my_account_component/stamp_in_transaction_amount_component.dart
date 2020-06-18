import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

class StampInTransactionAmountComponent extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  StampInTransactionAmountComponent({Key key, @required this.psmAtStampUser})
      : super(key: key);

  @override
  _StampInTransactionAmountComponentState createState() =>
      _StampInTransactionAmountComponentState();
}

class _StampInTransactionAmountComponentState
    extends State<StampInTransactionAmountComponent> {
  String stampInTransactionAmount = "0";
  @override
  void initState() {
    super.initState();
    streamStampInTransactionAmount();
  }

  void streamStampInTransactionAmount() {
    Firestore.instance
        .collection("Stamp_Transaction")
        .where("userId", isEqualTo: widget.psmAtStampUser.userId)
        .snapshots()
        .listen((data) {
      setState(() {
        stampInTransactionAmount = data.documents.length.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          "จำนวนแสตมป์ทั้งหมดของคุณคือ " + stampInTransactionAmount + " แสตมป์",
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      child: InkWell(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/icons/icon_gray.png",
              scale: 19,
            ),
            Text(
              "x " + stampInTransactionAmount,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
