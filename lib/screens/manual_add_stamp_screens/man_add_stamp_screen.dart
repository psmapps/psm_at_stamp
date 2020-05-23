import 'package:flutter/material.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

class StampManualAddStamp extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  StampManualAddStamp({
    Key key,
    @required this.psmAtStampUser,
  }) : super(key: key);

  @override
  _StampManualAddStampState createState() => _StampManualAddStampState();
}

class _StampManualAddStampState extends State<StampManualAddStamp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("Test"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
