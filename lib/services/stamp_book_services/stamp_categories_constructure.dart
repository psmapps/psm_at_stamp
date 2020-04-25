import 'package:flutter/material.dart';

/// StampCategories used to send categories data between page
/// * Required
/// [categories, iconUrl]
class StampCategories {
  String categories;
  String iconUrl;

  StampCategories({@required String categories, @required String iconUrl}) {
    this.categories = categories;
    this.iconUrl = iconUrl;
  }
}
