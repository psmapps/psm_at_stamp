import 'package:flutter/material.dart';

/// PsmAtStampStampData constructure is used to pass stamp data in psmatstamp
/// * Required
/// [categories, name, stampId]
/// * Optional
/// [detail, isOpen, location, stampIcon]
class PsmAtStampStampData {
  String categories;
  String detail;
  String stampId;
  String stampIcon;
  bool isOpen;
  String location;
  String name;

  PsmAtStampStampData({
    @required String stampId,
    @required String categories,
    @required String name,
    String stampIcon,
    bool isOpen,
    String detail,
    String location,
  }) {
    this.stampId = stampId;
    this.categories = categories;
    this.detail = detail;
    this.isOpen = isOpen;
    this.location = location;
    this.name = name;
    this.stampIcon = stampIcon;
  }
}
