import 'package:flutter/material.dart';
import 'package:it/main.dart';

class FancyInputField extends StatelessWidget {
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  const FancyInputField({
    super.key,

    this.backgroundColor,
    this.width,
    this.height,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
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
      child: TextField(
        controller: controller,
        style: styling.bodyFont.copyWith(color: styling.blue),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,

          hintStyle: styling.bodyFont.copyWith(color: styling.blueMute),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        
      ),
    );
  }
}
