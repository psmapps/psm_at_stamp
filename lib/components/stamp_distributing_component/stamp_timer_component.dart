import 'dart:async';

import 'package:flutter/material.dart';

class StampTimerComponent extends StatefulWidget {
  StampTimerComponent(
      {Key key, @required this.timerTriggeredCallback, @required this.isActive})
      : super(key: key);
  final TimerTriggeredCallback timerTriggeredCallback;
  final bool isActive;

  @override
  _StampTimerComponentState createState() => _StampTimerComponentState();
}

class _StampTimerComponentState extends State<StampTimerComponent> {
  double timeIndicatorValue = 1;
  String timeCount = "30";
  Timer timer;
  @override
  void initState() {
    if (widget.isActive) {
      timer = Timer.periodic(
        Duration(milliseconds: 500),
        (timer) {
          if ((timeIndicatorValue * 30).round() == 1) {
            widget.timerTriggeredCallback();
          }
          if (timeIndicatorValue - 0.016667 < 0) {
            setState(() {
              timeIndicatorValue = 1;
              timeCount = "30";
            });
          } else {
            setState(() {
              timeCount = (timeIndicatorValue * 30).round().toString();
              timeIndicatorValue -= 0.016667;
            });
          }
        },
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(timeCount),
            ),
          ),
          Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                value: timeIndicatorValue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef TimerTriggeredCallback = void Function();
