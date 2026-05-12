import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/main.dart';

class FancyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final Offset offset;
  const FancyButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.width,
    this.height,
    this.offset = const Offset(6, 6),
  });

  @override
  State<FancyButton> createState() => _FancyButtonState();
}

class _FancyButtonState extends State<FancyButton> {
  final Duration _pressDuration = const Duration(milliseconds: 80);
  bool buttonPressed = false;
  DateTime? _pressedAt;
  void _releaseButton() {
    if (!buttonPressed) return;
    final elapsed = DateTime.now().difference(_pressedAt ?? DateTime.now());
    final remaining = _pressDuration - elapsed;
    if (remaining > Duration.zero) {
      Future.delayed(remaining, () {
        if (mounted) setState(() => buttonPressed = false);
      });
    } else {
      setState(() => buttonPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: widget.offset.dx,
        bottom: widget.offset.dy,
      ),
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        onTapDown: (details) {
          HapticFeedback.lightImpact();
          setState(() {
            buttonPressed = true;
            _pressedAt = DateTime.now();
          });
        },
        onTapUp: (details) {
          HapticFeedback.lightImpact();
          _releaseButton();
        },
        onTapCancel: _releaseButton,
        onTap: widget.onTap,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, buttonPressed ? 5 : 0, 0),

          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,

            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: styling.blue, width: 3),
            boxShadow: [
              if (!buttonPressed)
                BoxShadow(
                  color: styling.blue,
                  offset: widget.offset, // shift right and down by the offset
                  blurRadius: 0,
                  // hard shadow — no blur
                  spreadRadius: 0,
                ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
