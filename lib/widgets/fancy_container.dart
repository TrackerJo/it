import 'package:flutter/material.dart';
import 'package:it/main.dart';

class FancyContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  const FancyContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: backgroundColor ?? styling.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: styling.blue, width: 2),
        ),
        shadows: [
          BoxShadow(color: styling.blue, offset: Offset(0, 5), blurRadius: 0),
        ],
      ),
      child: child,
    );
  }
}
