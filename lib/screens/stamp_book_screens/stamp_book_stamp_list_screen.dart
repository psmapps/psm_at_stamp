import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/stamp_book_components/stamp_book_component.dart';
import 'package:psm_at_stamp/screens/stamp_book_screens/stamp_details_screen.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/stamp_book_services/stamp_categories_constructure.dart';
import 'package:psm_at_stamp/services/stamp_book_services/stamp_details_constructure.dart';

class StampBookStampListScreen extends StatefulWidget {
  final StampCategories stampCategories;
  final PsmAtStampUser psmAtStampUser;
  StampBookStampListScreen(
      {Key key, @required this.stampCategories, @required this.psmAtStampUser})
      : super(key: key);

  @override
  _StampBookStampListScreenState createState() =>
      _StampBookStampListScreenState();
}

class _StampBookStampListScreenState extends State<StampBookStampListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(90, 90, 90, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(31, 31, 31, 1),
        title: Row(
          children: <Widget>[
            widget.stampCategories.iconUrl != null
                ? FadeInImage.assetNetwork(
                    imageScale: 16,
                    placeholderScale: 16,
                    fadeInCurve: Curves.decelerate,
                    fadeOutCurve: Curves.decelerate,
                    placeholder: "assets/images/icons/icon_gray.png",
                    image: widget.stampCategories.iconUrl,
                  )
                : Image.asset(
                    "assets/images/icons/icon_gray.png",
                    scale: 16,
                  ),
            Flexible(
              child: Text(
                widget.stampCategories.categories,
                style: TextStyle(
                  fontFamily: "Sukhumwit",
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("Stamp_Data")
              .where("categories", isEqualTo: widget.stampCategories.categories)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                ),
              );
            }
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.exclamationTriangle,
                      color: Colors.yellow,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                    ),
                    Text(
                      "ไม่มีแสตมป์ในกลุ่มสาระนี้",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Sukhumwit",
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }
            return AnimationLimiter(
              child: GridView.count(
                padding: const EdgeInsets.only(top: 25, bottom: 25),
                crossAxisCount: 2,
                children: List.generate(
                  snapshot.data.documents.length,
                  (index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      columnCount: 2,
                      duration: const Duration(milliseconds: 300),
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: StampBookComponent(
                            stampTitle:
                                snapshot.data.documents[index].data["name"],
                            iconUrl: snapshot
                                    .data.documents[index].data["iconUrl"] ??
                                widget.stampCategories.iconUrl,
                            displayStampIndocator: false,
                            onTapHandler: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StampDetailScreen(
                                    stampIdInfomation: StampIdInfomation(
                                      categories:
                                          widget.stampCategories.categories,
                                      stampId: snapshot
                                          .data.documents[index].documentID,
                                      iconUrl: snapshot.data.documents[index]
                                              .data["iconUrl"] ??
                                          widget.stampCategories.iconUrl,
                                      categoriesIconUrl:
                                          widget.stampCategories.iconUrl,
                                    ),
                                    psmAtStampUser: widget.psmAtStampUser,
                                  ),
                                ),
                              );
                            },
                            stampIdInfomation: StampIdInfomation(
                              categories: widget.stampCategories.categories,
                              stampId:
                                  snapshot.data.documents[index].documentID,
                              iconUrl: snapshot
                                      .data.documents[index].data["iconUrl"] ??
                                  widget.stampCategories.iconUrl,
                              categoriesIconUrl: widget.stampCategories.iconUrl,
                            ),
                            psmAtStampUser: widget.psmAtStampUser,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
