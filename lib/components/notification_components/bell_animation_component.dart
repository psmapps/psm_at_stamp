import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BellNotificationAnimation extends StatefulWidget {
  BellNotificationAnimation({Key key}) : super(key: key);

  @override
  _BellNotificationAnimationState createState() =>
      _BellNotificationAnimationState();
}

class _BellNotificationAnimationState extends State<BellNotificationAnimation>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  bool doAnimation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
    _runAnimation();
  }

  void _runAnimation() async {
    doAnimation = true;
    while (doAnimation) {
      await _animationController.forward();
      await _animationController.reverse();
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  @override
  void dispose() {
    doAnimation = false;
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: -.1)
          .chain(CurveTween(curve: Curves.elasticIn))
          .animate(_animationController),
      child: Icon(
        FontAwesomeIcons.bell,
        color: Colors.yellow,
      ),
    );
  }
}
