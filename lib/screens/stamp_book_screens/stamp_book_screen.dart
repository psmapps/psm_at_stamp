import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/stamp_book_components/stamp_book_component.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

class StampBookScreen extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  StampBookScreen({Key key, @required this.psmAtStampUser}) : super(key: key);

  @override
  _StampBookScreenState createState() => _StampBookScreenState();
}

class _StampBookScreenState extends State<StampBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection("Categories")
            .orderBy("priority", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                ),
                Text(
                  "กำลังโหลดข้อมูลสมุดแสตมป์",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Sukhumwit",
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          } else {
            return GridView.count(
              padding: const EdgeInsets.only(top: 25, bottom: 25),
              crossAxisCount: 2,
              children: List.generate(
                snapshot.data.documents.length,
                (index) {
                  return stampBookWidget(
                    stampTitle: snapshot.data.documents[index].data["title"],
                    iconUrl: snapshot.data.documents[index].data["iconUrl"],
                    onTapHandler: () {},
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
