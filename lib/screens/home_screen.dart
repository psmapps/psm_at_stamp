import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psm_at_stamp/components/notification_component/message_box.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

class HomeScreen extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  HomeScreen({Key key, @required this.psmAtStampUser}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    check();
  }

  Future<void> check() {
    logger.d(widget.psmAtStampUser.otherInfos["didOverrideSignIn"]);
    Future.delayed(Duration(seconds: 1), () {
      if (widget.psmAtStampUser.otherInfos["didOverrideSignIn"]) {
        showMessageBox(
          context,
          title: "การเข้าสู่ระบบซ้ำ",
          content:
              "การเข้าสู่ระบบนี้จะทำให้คุณออกจากระบบในอุปกรณ์เก่าโดยอัตโนมัติ เนื่องจากผู้ใช้งานสามารถเข้าสู่ระบบได้จากอุปกรณ์เครื่องเดียวเท่านั้น",
          icon: FontAwesomeIcons.exclamationTriangle,
          iconColor: Colors.yellow[600],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Text("Body"),
    );
  }
}
