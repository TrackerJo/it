import 'package:flutter/material.dart';
import 'package:it/main.dart';

class PlayerIcon extends StatelessWidget {
  final String icon;
  final Color color;
  final double iconSize;
  final double size;
  final Color? borderColor;
  final double borderWidth;
  const PlayerIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 50,
    this.iconSize = 24,
    this.borderColor,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);
    const curve = Curves.easeInOut;
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: BoxBorder.all(
          color: borderColor ?? styling.blue,
          width: borderWidth,
        ),
      ),
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: duration,
          curve: curve,
          style: TextStyle(
            color: Colors.white,
            fontSize: iconSize,
            fontWeight: FontWeight.bold,
          ),
          child: Text(icon),
        ),
      ),
    );
  }
}
