import 'package:flutter/material.dart';

/// HomeScreenWidget is a constructure class
/// used to pass home screen detail to home screen;
/// * Required
/// [screenList, tabBarList]
class ScreenWidget {
  List<Widget> screenList;
  List<Widget> tabBarList;
  int tabBarCount;
  ScreenWidget({
    @required List<Widget> screenList,
    @required List<Widget> tabBarList,
    @required int tabBarCount,
  }) {
    this.screenList = screenList;
    this.tabBarList = tabBarList;
    this.tabBarCount = tabBarCount;
  }
}
