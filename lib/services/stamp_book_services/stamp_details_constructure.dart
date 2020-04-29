import 'package:flutter/material.dart';

/// StampIdInfomation used to send the stamp data between page
/// * Required
/// [categories, iconUrl, stampId]
class StampIdInfomation {
  String iconUrl;
  String stampId;
  String categories;
  String categoriesIconUrl;
  StampIdInfomation({
    @required String stampId,
    @required String categories,
    @required String iconUrl,
    @required String categoriesIconUrl,
  }) {
    this.categories = categories;
    this.iconUrl = iconUrl;
    this.stampId = stampId;
    this.categoriesIconUrl = categoriesIconUrl;
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
