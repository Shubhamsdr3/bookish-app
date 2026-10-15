import 'package:flutter/material.dart';

class DashedBorder extends StatelessWidget {
  static const double _height = 500;
  static const double _width = 500;

  const DashedBorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _container(),
                _container(),
              ],
            ),
            CustomPaint(
                foregroundPainter: DashedLinePainter(),
                child: Container(
                    width: _width - 30, color: Colors.white, height: 5)
            ),
          ],
        ),
      ),
    );
  }

  Widget _container() {
    return Container(
      height: _height,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueAccent,
          width: 2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 9, dashSpace = 5, startX = 0, startY = size.height / 2;
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2;
    while (startX < size.width) {
      canvas.drawLine(
          Offset(startX, startY), Offset(startX + dashSpace, startY), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
