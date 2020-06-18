import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/stamp_detail_components/stamp_details_info_component.dart';
import 'package:psm_at_stamp/services/stamp_book_services/stamp_details_constructure.dart';

Widget onActiveStampDetailInfoComponent({
  String name,
  String location,
  String details,
  StampStatus isOpen,
}) {
  return Center(
    child: Column(
      children: <Widget>[
        Text(
          name ?? "...",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(13, 25, 13, 13),
          child: Row(
            children: <Widget>[
              stampDetailInfoComponent(
                iconData: FontAwesomeIcons.mapMarkerAlt,
                iconColor: Colors.redAccent,
                detailIndex: "ตำแหน่งแสตมป์",
                detail: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Text(
                    location ?? "ไม่มีข้อมูล",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
              ),
              stampDetailInfoComponent(
                iconData: FontAwesomeIcons.powerOff,
                iconColor: Colors.yellowAccent,
                detailIndex: "สถาณะกิจกรรม",
                detail: Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: isOpen == StampStatus.open
                              ? Colors.greenAccent
                              : isOpen == StampStatus.close
                                  ? Colors.redAccent
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FaIcon(
                              isOpen == StampStatus.open
                                  ? FontAwesomeIcons.solidCheckCircle
                                  : isOpen == StampStatus.close
                                      ? FontAwesomeIcons.solidTimesCircle
                                      : FontAwesomeIcons.solidQuestionCircle,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                            ),
                            Text(
                              isOpen == StampStatus.open
                                  ? "เปิดให้เข้าเล่นกิจกรรม"
                                  : isOpen == StampStatus.close
                                      ? "ไม่เปิดให้เข้าเล่นกิจกรรม"
                                      : "ไม่มีข้อมูลสถาณะกิจกรรม",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
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
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
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
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          details ?? "ไม่มีคำอธิบายฐานกิจกรรม",
                          style: TextStyle(
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
      ],
    ),
  );
}
