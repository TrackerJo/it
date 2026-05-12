import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/main.dart';

class DiscoveryBottomBanner extends StatefulWidget {
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onDismiss;
  final IconData? icon;

  const DiscoveryBottomBanner({
    super.key,
    required this.title,
    required this.body,
    required this.onDismiss,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  @override
  State<DiscoveryBottomBanner> createState() => DiscoveryBottomBannerState();
}

class DiscoveryBottomBannerState extends State<DiscoveryBottomBanner>
    with TickerProviderStateMixin {
  late final _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
  );
  late final _exit = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  // The pill expands width-first with a slight overshoot, then settles.
  // Content fades in once the shape is mostly open.
  late final _expand = CurvedAnimation(
    parent: _entrance,
    curve: const Cubic(0.2, 0.85, 0.3, 1.08),
  );
  late final _contentFade = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
  );
  // easeOutBack briefly exceeds 1.0, so the banner overshoots resting before settling.
  late final _entranceSlide = Tween<double>(
    begin: -60.0,
    end: 0.0,
  ).animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOutBack));
  late final _exitProgress = CurvedAnimation(
    parent: _exit,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    _entrance.forward();
  }

  Future<void> playExit(VoidCallback onComplete) async {
    if (!mounted) {
      onComplete();
      return;
    }
    await _exit.forward();
    if (mounted) onComplete();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _exit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = styling.pink;
    final primary = styling.blue;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: AnimatedBuilder(
          animation: Listenable.merge([_entrance, _exit]),
          builder: (context, child) {
            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                widget.onDismiss();
              },
              child: Opacity(
                opacity: 1.0 - _exitProgress.value,
                child: Transform.translate(
                  offset: Offset(
                    0,
                    _entranceSlide.value + (-16 * _exitProgress.value),
                  ),
                  child: ClipPath(
                    clipper: _PillExpandClipper(
                      t: _expand.value.clamp(0.0, 1.0),
                    ),
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: primary.withValues(alpha: 0.18),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: FadeTransition(
                opacity: _contentFade,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      widget.icon ?? Icons.lightbulb_outline,
                      color: styling.white,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: styling.bodyFont.copyWith(
                              color: styling.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.body,
                            style: styling.bodyFont.copyWith(
                              color: styling.white,
                            ),
                          ),
                          if (widget.actionLabel != null &&
                              widget.onAction != null) ...[
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                widget.onAction!();
                                widget.onDismiss();
                              },
                              child: Text(
                                widget.actionLabel!,
                                style: styling.bodyFont.copyWith(
                                  color: styling.white,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        widget.onDismiss();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PillExpandClipper extends CustomClipper<Path> {
  static const _minWidth = 96.0;
  static const _targetRadius = 14.0;

  final double t;

  _PillExpandClipper({required this.t});

  @override
  Path getClip(Size size) {
    final start = _minWidth.clamp(0.0, size.width);
    final width = start + (size.width - start) * t;
    final left = (size.width - width) / 2;
    final pillRadius = size.height / 2;
    final radius = pillRadius + (_targetRadius - pillRadius) * t;
    return Path()..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, 0, width, size.height),
        Radius.circular(radius),
      ),
    );
  }

  @override
  bool shouldReclip(_PillExpandClipper old) => old.t != t;
}

class InAppNotification {
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;
  final Duration duration;

  const InAppNotification({
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
    this.icon,
    this.duration = const Duration(seconds: 6),
  });

  Future<bool> present(BuildContext context) async {
    final overlay = Overlay.of(context, rootOverlay: true);
    final bannerKey = GlobalKey<DiscoveryBottomBannerState>();
    final completer = Completer<bool>();
    Timer? autoDismissTimer;
    bool removed = false;
    late OverlayEntry entry;

    void removeEntry() {
      if (removed) return;
      removed = true;
      autoDismissTimer?.cancel();
      entry.remove();
      if (!completer.isCompleted) completer.complete(true);
    }

    void dismiss() {
      if (removed) return;
      final state = bannerKey.currentState;
      if (state == null) {
        removeEntry();
      } else {
        state.playExit(removeEntry);
      }
    }

    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: DiscoveryBottomBanner(
          key: bannerKey,
          title: title,
          body: body,
          actionLabel: actionLabel,
          icon: icon,
          onAction: onAction,
          onDismiss: dismiss,
        ),
      ),
    );
    overlay.insert(entry);
    autoDismissTimer = Timer(duration, dismiss);

    return completer.future;
  }
}
