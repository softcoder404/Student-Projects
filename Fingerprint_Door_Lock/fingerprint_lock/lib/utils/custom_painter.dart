import 'dart:math';

import 'package:flutter/material.dart';

class LockCustomPaint extends CustomPainter {
  Paint _paint;
  double _lockRect;
  LockCustomPaint(this._lockRect) {
    _paint = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;
  }
  @override
  void paint(Canvas canvas, Size size) {
    _paint.style = PaintingStyle.fill;
    var rect = Rect.fromLTWH(0, size.height * .5, size.width, size.height * .5);
    canvas.drawRect(rect, _paint);
    //draw small circle and rect to indicate lock
    var smallcircle = Offset(size.width * .5, size.height * .73);
    _paint.color = Colors.black;
    _paint.style = PaintingStyle.fill;
    _paint.strokeCap = StrokeCap.round;
    canvas.drawCircle(smallcircle, 25, _paint);
    var smallRect = Rect.fromLTWH(size.width * .40, size.height * .75,
        size.width * .2, size.height * .15);
    _paint.color = Colors.black;
    _paint.style = PaintingStyle.fill;
    canvas.drawRect(smallRect, _paint);

    //drawing semi circle
    var semicircle = Offset(size.width * .15, size.height * .25) &
        Size(size.width * .7, size.height * .6);
    _paint.color = Colors.green;
    _paint.strokeWidth = 20;
    _paint.strokeJoin = StrokeJoin.round;
    _paint.style = PaintingStyle.stroke;
    canvas.drawArc(semicircle, pi, pi, true, _paint);
    //lock rectangle
    var lockrect = Rect.fromLTWH(size.width * .75, size.height * .4, 32, 30 * _lockRect);
    _paint.color = Colors.black;
    _paint.style = PaintingStyle.fill;
    canvas.drawRect(lockrect, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
