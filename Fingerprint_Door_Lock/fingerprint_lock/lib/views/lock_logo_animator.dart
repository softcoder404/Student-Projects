import 'package:fingerprint_lock/utils/custom_painter.dart';
import 'package:flutter/material.dart';

class LockLogoAnimator extends StatefulWidget {
  final bool lockStatus;
  LockLogoAnimator({this.lockStatus});
  @override
  _LockLogoAnimatorState createState() => _LockLogoAnimatorState();
}

class _LockLogoAnimatorState extends State<LockLogoAnimator>
    with SingleTickerProviderStateMixin {
  double lockRect = 0.0;
  Animation<double> lockRectAnimation;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    widget.lockStatus ? lockDoor() : unlockDoor();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LockCustomPaint(lockRect),
    );
  }

  void lockDoor() {
    lockRectAnimation = Tween(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {
          lockRect = lockRectAnimation.value;
        });
      });
    controller.forward();
  }

  void unlockDoor() {
    lockRectAnimation = Tween(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {
          lockRect = lockRectAnimation.value;
        });
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
