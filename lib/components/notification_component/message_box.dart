import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_component/notification_component.dart';

/// showMessageBox is used to show normal messagebox in PSM @ STAMP
/// * Required
/// [title, content]
/// * Optional
/// [actionsButton, icon, iconColor]
void showMessageBox(BuildContext context,
    {@required String title,
    @required String content,
    List<Widget> actionsButton,
    IconData icon,
    Color iconColor}) {
  Widget notificationWidget = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: Row(
      children: <Widget>[
        icon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Icon(
                  icon,
                  color: iconColor,
                ),
              )
            : Container(),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: "Sukhumwit",
          ),
          maxLines: 2,
        )
      ],
    ),
    content: Text(
      content,
      style: TextStyle(
        fontSize: 18,
        fontFamily: "Sukhumwit",
      ),
    ),
    actions: actionsButton ??
        <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.timesCircle),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
  );
  return showNotification(context, notificaionWidget: notificationWidget);
}
