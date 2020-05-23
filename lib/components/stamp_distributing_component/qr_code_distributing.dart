import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:psm_at_stamp/components/stamp_distributing_component/stamp_timer_component.dart';
import 'package:qr_flutter/qr_flutter.dart';

Widget qrCodeDistributing({
  @required String stampTokenData,
  @required Function timeTriggerCallback,
  @required bool isActive,
}) {
  return Column(
    children: <Widget>[
      Container(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        child: InkWell(
          onTap: () {},
          child: Tooltip(
            message: "Stamp",
            child: QrImage(
              size: 200,
              version: QrVersions.auto,
              embeddedImage: AssetImage(
                "assets/images/icons/icon_curve_black.png",
              ),
              data: json.encode(
                {
                  "type": "stamp",
                  "token": stampTokenData,
                },
              ),
            ),
          ),
        ),
      ),
      StampTimerComponent(
        timerTriggeredCallback: timeTriggerCallback,
        isActive: isActive,
      ),
    ],
  );
}
