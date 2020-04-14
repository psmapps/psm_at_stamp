import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/notification_component/notification_component.dart';

/// showLoadingBox is used to show a box with CircularProgressIndicator in PSM @ STAMP
/// * Optional
/// [loadingMessage]
void showLoadingBox(BuildContext context, {String loadingMessage}) {
  Widget notificationWidget = Stack(
    children: <Widget>[
      Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                ),
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                ),
                loadingMessage != null
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                        child: Text(
                          loadingMessage,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Sukhumwit"),
                          maxLines: 2,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      )
    ],
  );
  return showNotification(context, notificaionWidget: notificationWidget);
}
