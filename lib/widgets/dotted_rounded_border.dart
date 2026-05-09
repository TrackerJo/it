import 'package:flutter/material.dart';

class DottedRoundedBorder extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color color;
  final Color? backgroundColor;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final EdgeInsets padding;

  const DottedRoundedBorder({
    super.key,
    required this.child,
    this.radius = 12,
    required this.color,
    this.backgroundColor,
    this.strokeWidth = 2,
    this.dashLength = 6,
    this.gapLength = 4,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DottedRoundedBorderPainter(
        radius: radius,
        color: color,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        gapLength: gapLength,
      ),
      child: Container(
        decoration: backgroundColor == null
            ? null
            : BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(radius),
              ),
        padding: padding,
        child: child,
      ),
    );
  }
}

class _DottedRoundedBorderPainter extends CustomPainter {
  final double radius;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  _DottedRoundedBorderPainter({
    required this.radius,
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final inset = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final clampedRadius =
        radius.clamp(0.0, rect.shortestSide / 2).toDouble();
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(clampedRadius));
    final path = Path()..addRRect(rrect);

    final dashPath = Path();
    final stride = dashLength + gapLength;

    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      final dashCount = (metric.length / stride).floor().clamp(1, 1 << 30);
      final adjustedStride = metric.length / dashCount;
      final adjustedDash =
          dashLength * (adjustedStride / stride);

      double distance = 0;
      while (distance < metric.length - 0.01) {
        final end = (distance + adjustedDash).clamp(0.0, metric.length);
        dashPath.addPath(metric.extractPath(distance, end), Offset.zero);
        distance += adjustedStride;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DottedRoundedBorderPainter old) {
    return old.radius != radius ||
        old.color != color ||
        old.strokeWidth != strokeWidth ||
        old.dashLength != dashLength ||
        old.gapLength != gapLength;
  }
}
