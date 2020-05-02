import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Widget> permissionStatusWidget(
    {@required Permission permission,
    @required Function requestPermission}) async {
  PermissionStatus permissionStatus = await permission.status;
  switch (permissionStatus) {
    case PermissionStatus.granted:
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Icon(
          FontAwesomeIcons.check,
          color: Colors.green,
        ),
      );
      break;
    case PermissionStatus.denied:
      return RaisedButton(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.exclamationCircle,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
            ),
            Text(
              "กดที่นี่เพื่ออนุญาต",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: "Sukhumwit",
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onPressed: () async {
          await AppSettings.openAppSettings();
        },
      );
      break;
    case PermissionStatus.permanentlyDenied:
      return Icon(
        FontAwesomeIcons.exclamationCircle,
        color: Colors.red,
      );
      break;
    case PermissionStatus.restricted:
      return Icon(
        FontAwesomeIcons.exclamationCircle,
        color: Colors.red,
      );
      break;
    case PermissionStatus.undetermined:
      return RaisedButton(
        color: Colors.grey,
        child: Text(
          "อนุญาตตอนนี้",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: "Sukhumwit",
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: requestPermission,
      );
      break;
    default:
      return Container();
  }
}
