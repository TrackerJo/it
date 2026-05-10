import 'dart:math';

import 'package:flutter/material.dart';
import 'package:it/main.dart';

class GotchaScreen extends StatefulWidget {
  const GotchaScreen({super.key});

  @override
  State<GotchaScreen> createState() => _GotchaScreenState();
}

class _GotchaScreenState extends State<GotchaScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _swooshController;
  late final AnimationController _textController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..forward();
    _swooshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) Navigator.of(context).maybePop();
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _swooshController.dispose();
    _textController.dispose();
    super.dispose();
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t.clamp(0.0, 1.0);

  // Mirrors @keyframes itBounceIn:
  // 0% scale .4 / y +20 / opacity 0 → 60% scale 1.08 / y -4 / opacity 1
  // → 80% scale .96 / y +2 → 100% scale 1 / y 0
  ({double scale, double dy, double opacity}) _bounceIn(double t) {
    double scale;
    double dy;
    if (t <= 0.6) {
      final p = t / 0.6;
      scale = _lerp(0.4, 1.08, p);
      dy = _lerp(20, -4, p);
    } else if (t <= 0.8) {
      final p = (t - 0.6) / 0.2;
      scale = _lerp(1.08, 0.96, p);
      dy = _lerp(-4, 2, p);
    } else {
      final p = (t - 0.8) / 0.2;
      scale = _lerp(0.96, 1.0, p);
      dy = _lerp(2, 0, p);
    }
    final opacity = t <= 0.6 ? (t / 0.6).clamp(0.0, 1.0) : 1.0;
    return (scale: scale, dy: dy, opacity: opacity);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              final v = _bounceIn(_bgController.value);
              return Opacity(
                opacity: v.opacity,
                child: Transform.translate(
                  offset: Offset(0, v.dy),
                  child: Transform.scale(scale: v.scale, child: child),
                ),
              );
            },
            child: Container(color: styling.pink),
          ),
          Positioned(
            top: size.height * 0.30,
            left: 0,
            right: 0,
            height: 80,
            child: ClipRect(
              child: AnimatedBuilder(
                animation: _swooshController,
                builder: (context, child) {
                  final t = _swooshController.value;
                  final eased = Curves.easeOut.transform(t);
                  final dx = _lerp(-1.1, 1.1, eased) * size.width;
                  final opacity = t <= 0.4
                      ? (t / 0.4).clamp(0.0, 1.0)
                      : (1 - (t - 0.4) / 0.6).clamp(0.0, 1.0);
                  const skew = -12 * pi / 180;
                  return Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: Offset(dx, 0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(0, 1, tan(skew)),
                        alignment: Alignment.center,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Container(color: styling.orange),
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                final v = _bounceIn(_textController.value);
                return Opacity(
                  opacity: v.opacity,
                  child: Transform.translate(
                    offset: Offset(0, v.dy),
                    child: Transform.scale(scale: v.scale, child: child),
                  ),
                );
              },
              child: Text(
                "GOTCHA",
                style: styling.headerFont.copyWith(
                  fontSize: 64,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 1,
                  shadows: [
                    Shadow(
                      color: styling.blue,
                      offset: const Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
