import 'package:flutter/material.dart';

class StampDetails {
  String name;
  String iconUrl;
  String stampId;
  String location;
  String details;
  String categories;
  bool isOpen;
  bool isStamped;
  StampDetails(
      {@required String name,
      @required String categories,
      @required String iconUrl,
      @required String location,
      @required String details,
      @required String stampId,
      @required bool isOpen,
      @required bool isStamped}) {
    this.name = name;
    this.categories = categories;
    this.iconUrl = iconUrl;
    this.location = location;
    this.details = details;
    this.stampId = stampId;
    this.isOpen = isOpen;
    this.isStamped = isStamped;
  }
}
