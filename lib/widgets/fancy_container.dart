import 'package:flutter/material.dart';
import 'package:it/main.dart';

class FancyContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final bool drawCircle;
  final double offset;
  const FancyContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.width,
    this.height,
    this.drawCircle = false,
    this.offset = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Container(
      // Outer padding creates the room for the offset shadow
      padding: EdgeInsets.only(right: offset, bottom: offset),
      width: width,
      height: height,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,

          borderRadius: borderRadius,
          border: Border.all(color: styling.blue, width: 3),
          boxShadow: [
            BoxShadow(
              color: styling.blue,
              offset: Offset(
                offset,
                offset,
              ), // shift right and down by the offset  
              blurRadius: 0, // hard shadow — no blur
              spreadRadius: 0,
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(16 - 3),
          child: Stack(
            children: [
              if (drawCircle)
                Positioned(
                  top: -20,
                  right: -20,
                  child: CustomPaint(
                    size: Size(100, 100),
                    painter: CirclePainter(),
                  ),
                ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a Paint object to define the appearance of the shape
    final Paint paint = Paint()
      ..color = styling
          .green // Set the color to green
      ..strokeWidth =
          4 // Set the stroke width
      ..style = PaintingStyle.fill; // Set the style to fill

    // Calculate the center and radius of the circle
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw a circle on the canvas using
    // the specified Paint object
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // Return false to indicate that the painting
    // should not be repainted unless necessary
    return false;
  }
}
