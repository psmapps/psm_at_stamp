import 'package:flutter/material.dart';

/// showNotification is used to show a custom dialog box in PSM @ STAMP
/// * Required
/// [notificationWidget]
/// * Optional
/// [barrierDismissible]
void showNotification(BuildContext context,
    {@required Widget notificaionWidget, bool barrierDismissible}) async {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? false,
    builder: (context) {
      return notificaionWidget;
    },
  );
}
