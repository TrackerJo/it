import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/main.dart';

class WelcomeSreen extends StatefulWidget {
  const WelcomeSreen({super.key});

  @override
  State<WelcomeSreen> createState() => _WelcomeSreenState();
}

class _WelcomeSreenState extends State<WelcomeSreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..forward();

  late final AnimationController _yourController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  late final AnimationController _itController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  late final AnimationController _buttonController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  late final AnimationController _captionController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  bool buttonPressed = false;
  DateTime? _pressedAt;
  final Duration _pressDuration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _yourController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _itController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) _buttonController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) _captionController.forward();
    });
  }

  late final Animation<Offset> _tagSlide = Tween<Offset>(
    begin: const Offset(-1.2, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  late final Animation<Offset> _yourSlide = Tween<Offset>(
    begin: const Offset(1.2, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _yourController, curve: Curves.easeOut));

  late final Animation<Offset> _itSlide = Tween<Offset>(
    begin: const Offset(-1.2, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _itController, curve: Curves.easeOut));

  late final Animation<Offset> _buttonSlide = Tween<Offset>(
    begin: const Offset(0, 1.4),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _buttonController, curve: Curves.easeOut));

  late final Animation<double> _captionFade = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(CurvedAnimation(parent: _captionController, curve: Curves.easeOut));

  @override
  void dispose() {
    _controller.dispose();
    _yourController.dispose();
    _itController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

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
    return Scaffold(
      backgroundColor: styling.green,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 12,
              right: 0,
              child: SlideTransition(
                position: _tagSlide,
                child: Text(
                  "Tag!",
                  style: styling.headerFont.copyWith(
                    fontSize: 120,
                    color: styling.pink,
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 160,
              right: 24,

              child: SlideTransition(
                position: _yourSlide,
                child: Text(
                  "You're",
                  style: styling.headerFont.copyWith(
                    fontSize: 80,
                    color: styling.blue,
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 240,
              left: 36,
              right: 0,
              child: SlideTransition(
                position: _itSlide,
                child: Text(
                  "It!",
                  style: styling.headerFont.copyWith(
                    fontSize: 120,
                    color: styling.pink,
                  ),
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).size.height / 2 + 60,
              left: 36,
              right: 0,
              child: FadeTransition(
                opacity: _captionFade,
                child: Text(
                  "The ultimate tag app",
                  style: styling.bodyFont.copyWith(
                    fontSize: 24,
                    color: styling.blue,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _buttonSlide,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                    onTap: () {
                      router.pushReplacement("/login");
                    },

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 80),
                      curve: Curves.easeOut,
                      transform: Matrix4.translationValues(
                        0,
                        buttonPressed ? 5 : 0,
                        0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 16,
                      ),
                      width: double.infinity,
                      decoration: ShapeDecoration(
                        color: styling.pink,
                        shape: StadiumBorder(),
                        shadows: [
                          if (!buttonPressed)
                            BoxShadow(
                              color: styling.darkPink,
                              offset: Offset(0, 5),
                              blurRadius: 0,
                            ),
                        ],
                      ),
                      child: Text(
                        "Get Started",
                        style: styling.bodyFont.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: styling.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
