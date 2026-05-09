import 'package:flutter/material.dart';
import 'package:it/main.dart';

class NavBarIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Function() onTap;
  const NavBarIcon({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? styling.lightPink : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isActive ? styling.blue : Colors.transparent,
            width: 2,
          ),
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? styling.blue : styling.blueMute),
            Text(
              label,
              style: styling.bodyFont.copyWith(
                color: isActive ? styling.blue : styling.blueMute,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
