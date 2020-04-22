import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
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
          stream: Firestore.instance.collection("Categories").snapshots(),
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
                crossAxisCount: 2,
                children: List.generate(
                  snapshot.data.documents.length,
                  (index) {
                    return Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              logger.d("PSM @ STAMP Draft Box");
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ListTile(
                                  title: Center(
                                    child: Text(
                                      snapshot
                                          .data.documents[index].data["title"],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                    );
                  },
                ),
              );
            }
          }),
    );
  }
}
