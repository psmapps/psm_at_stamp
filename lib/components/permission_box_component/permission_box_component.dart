import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psm_at_stamp/components/permission_box_component/get_permission_widget_component.dart';
import 'package:psm_at_stamp/components/permission_box_component/permission_component.dart';

class PermissionBox extends StatefulWidget {
  PermissionBox({Key key}) : super(key: key);

  @override
  _PermissionBoxState createState() => _PermissionBoxState();
}

class _PermissionBoxState extends State<PermissionBox> {
  Widget cameraPermissionWidget;
  Widget notificationPermissionWidget;

  @override
  void initState() {
    cameraPermissionWidget = CircularProgressIndicator();
    notificationPermissionWidget = CircularProgressIndicator();
    super.initState();
    getPermissionWidget();
  }

  Future<void> getPermissionWidget() async {
    Widget _cameraPermissionWidget = await permissionStatusWidget(
      permission: Permission.camera,
      requestPermission: () async {
        await requestPermission(permission: Permission.camera);
      },
    );
    Widget _notificationPermissionWidget = await permissionStatusWidget(
      permission: Permission.notification,
      requestPermission: () async {
        await requestPermission(permission: Permission.notification);
      },
    );
    setState(() {
      cameraPermissionWidget = _cameraPermissionWidget;
      notificationPermissionWidget = _notificationPermissionWidget;
    });
  }

  Future<void> requestPermission({@required Permission permission}) async {
    await permission.request();
    getPermissionWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
            ),
            ListTile(
              title: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.solidAddressBook,
                      color: Colors.white,
                      size: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                    ),
                    Flexible(
                      child: Text(
                        "สิทธิการเข้าถึง (Permission)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Sukhumwit",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: <Widget>[
                  permissionComponent(
                    icon: FontAwesomeIcons.camera,
                    permissionTitle: "กล้อง",
                    permissionStatus: cameraPermissionWidget,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                  ),
                  permissionComponent(
                    icon: FontAwesomeIcons.solidBell,
                    permissionTitle: "การแจ้งเตือน",
                    permissionStatus: notificationPermissionWidget,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}
