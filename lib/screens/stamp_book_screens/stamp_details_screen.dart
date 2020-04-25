import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/stamp_book_components/stamp_details_component.dart';
import 'package:psm_at_stamp/services/stamp_book_services/stamp_details_constructure.dart';

class StampDetailScreen extends StatefulWidget {
  final StampDetails stampDetails;
  StampDetailScreen({Key key, @required this.stampDetails}) : super(key: key);

  @override
  _StampDetailScreenState createState() => _StampDetailScreenState();
}

class _StampDetailScreenState extends State<StampDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(90, 90, 90, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(31, 31, 31, 1),
        title: Row(
          children: <Widget>[
            widget.stampDetails.iconUrl != null
                ? FadeInImage.assetNetwork(
                    imageScale: 16,
                    placeholderScale: 16,
                    fadeInCurve: Curves.decelerate,
                    fadeOutCurve: Curves.decelerate,
                    placeholder: "assets/images/icons/icon_gray.png",
                    image: widget.stampDetails.iconUrl,
                  )
                : Image.asset(
                    "assets/images/icons/icon_gray.png",
                    scale: 16,
                  ),
            Flexible(
              child: Text(
                widget.stampDetails.name,
                style: TextStyle(
                  fontFamily: "Sukhumwit",
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
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
                      Center(
                        child: Text(
                          widget.stampDetails.name,
                          style: TextStyle(
                            fontFamily: "Sukhumwit",
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(13, 25, 13, 13),
                        child: Row(
                          children: <Widget>[
                            stampDetailComponent(
                              iconData: FontAwesomeIcons.mapMarkerAlt,
                              iconColor: Colors.redAccent,
                              detailIndex: "ตำแหน่งแสตมป์",
                              detail: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  widget.stampDetails.location,
                                  style: TextStyle(
                                    fontFamily: "Sukhumwit",
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 5,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                            ),
                            stampDetailComponent(
                              iconData: FontAwesomeIcons.powerOff,
                              iconColor: Colors.yellowAccent,
                              detailIndex: "สถาณะกิจกรรม",
                              detail: Expanded(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: widget.stampDetails.isOpen
                                            ? Colors.greenAccent
                                            : Colors.redAccent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          FaIcon(
                                            widget.stampDetails.isOpen
                                                ? FontAwesomeIcons
                                                    .solidCheckCircle
                                                : FontAwesomeIcons
                                                    .solidTimesCircle,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                          ),
                                          Text(
                                            widget.stampDetails.isOpen
                                                ? "เปิดให้เข้าเล่นกิจกรรม"
                                                : "ไม่เปิดให้เข้าเล่นกิจกรรม",
                                            style: TextStyle(
                                              fontFamily: "Sukhumwit",
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(13, 5, 13, 13),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 10, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.infoCircle,
                                      size: 35,
                                      color: Colors.orangeAccent[100],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "คำอธิบายฐานกิจกรรม",
                                        style: TextStyle(
                                          fontFamily: "Sukhumwit",
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        widget.stampDetails.details,
                                        style: TextStyle(
                                          fontFamily: "Sukhumwit",
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(30)),
                          width: 160,
                          height: 160,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: widget.stampDetails.isStamped
                                  ? Stack(
                                      children: <Widget>[
                                        Image.asset(
                                            "assets/images/stamp_badge.png"),
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
                      ),
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
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      width: 140,
                      height: 140,
                      fadeInCurve: Curves.easeIn,
                      placeholder: "assets/images/icons/icon_gray.png",
                      image: widget.stampDetails.iconUrl,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
