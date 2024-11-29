import 'package:flutter/material.dart';

class BackGround extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
      Paint paint = new Paint();
      paint.color = Colors.red;
      paint.strokeWidth = 100;
      paint.isAntiAlias = true;

      Paint paint2 = new Paint();
      paint2.color = Colors.orange;
      paint2.strokeWidth = 100;
      paint2.isAntiAlias = true;

      canvas.drawLine(Offset(300, -120), Offset(size.width+60, size.width-280), paint2);
      canvas.drawLine(Offset(300, -120), Offset(size.width+60, size.width-160), paint);
      canvas.drawLine(Offset(300, -120), Offset(size.width+60, size.width-40), paint2);
      canvas.drawLine(Offset(0, -10), Offset(size.width, size.width), paint);
      canvas.drawLine(Offset(-100, 40), Offset(size.width, size.width), paint2);
      canvas.drawLine(Offset(-200, 90), Offset(size.width, size.width), paint);
      canvas.drawLine(Offset(-300, 140), Offset(size.width, size.width), paint2);
      canvas.drawLine(Offset(-400, 190), Offset(size.width, size.width), paint);
      canvas.drawLine(Offset(-500, 240), Offset(size.width, size.width), paint2);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}