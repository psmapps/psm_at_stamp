import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/signin_button_components.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';

class UploadStampIconInfoComponent extends StatefulWidget {
  final PsmAtStampUser psmAtStampUser;
  UploadStampIconInfoComponent({
    Key key,
    @required this.psmAtStampUser,
  }) : super(key: key);

  @override
  _UploadStampIconInfoComponentState createState() =>
      _UploadStampIconInfoComponentState();
}

class _UploadStampIconInfoComponentState
    extends State<UploadStampIconInfoComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        signInButtonComponent(
          title: "Test",
          onPressHandler: () {},
        ),
      ],
    );
  }
}
