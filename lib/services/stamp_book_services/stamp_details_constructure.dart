import 'package:flutter/material.dart';

/// StampIdInfomation used to send the stamp data between page
/// * Required
/// [categories, iconUrl, stampId]
class StampIdInfomation {
  String stampId;
  String categories;
  String categoriesIconUrl;
  bool displayStampBadge;
  StampIdInfomation({
    String stampId,
    String categories,
    String categoriesIconUrl,
    @required bool displayStampBadge,
  }) {
    this.categories = categories;
    this.stampId = stampId;
    this.categoriesIconUrl = categoriesIconUrl;
    this.displayStampBadge = displayStampBadge;
  }
}

enum StampStatus { open, close, unknown }

StampStatus convertStampStatusToEnum({@required bool stampStatus}) {
  if (stampStatus == true) {
    return StampStatus.open;
  }
  if (stampStatus == false) {
    return StampStatus.close;
  }
  return StampStatus.unknown;
}
