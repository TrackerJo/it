import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it/constants.dart';
import 'package:it/main.dart';

class CustomTabs extends StatefulWidget {
  final List<TabItem> tabs;
  final Function(String value) onTabChanged;
  final EdgeInsets? padding;
  final double? tabHeight;

  const CustomTabs({
    super.key,
    required this.tabs,
    this.padding,
    this.tabHeight,
    required this.onTabChanged,
  });

  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs> {
  static const _borderWidth = 2.0;
  static const _innerInset = 4.0;
  static const _animDuration = Duration(milliseconds: 220);
  static const _animCurve = Curves.easeOutCubic;

  late String _internalSelectedValue;

  @override
  void initState() {
    super.initState();
    _internalSelectedValue = widget.tabs
        .firstWhere((tab) => tab.isSelected, orElse: () => widget.tabs[0])
        .value;
  }

  int get _selectedIndex {
    final i = widget.tabs.indexWhere((t) => t.value == _internalSelectedValue);
    return i < 0 ? 0 : i;
  }

  void _select(String value) {
    if (value == _internalSelectedValue) return;
    HapticFeedback.lightImpact();
    setState(() => _internalSelectedValue = value);
    widget.onTabChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final tabCount = widget.tabs.length;
    final height = widget.tabHeight ?? 56;

    return LayoutBuilder(
      builder: (context, constraints) {
        final innerWidth =
            constraints.maxWidth - 2 * (_borderWidth + _innerInset);
        final segmentWidth = innerWidth / tabCount;

        return Container(
          height: height,
          decoration: ShapeDecoration(
            color: styling.white,
            shape: StadiumBorder(
              side: BorderSide(color: styling.blue, width: _borderWidth),
            ),
          ),
          padding: const EdgeInsets.all(_innerInset),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: _animDuration,
                curve: _animCurve,
                alignment: tabCount > 1
                    ? Alignment(-1 + 2 * _selectedIndex / (tabCount - 1), 0)
                    : Alignment.center,
                child: SizedBox(
                  width: segmentWidth,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: styling.pink,
                      shape: StadiumBorder(),
                    ),
                  ),
                ),
              ),
              Row(
                children: widget.tabs.map((tab) {
                  final selected = tab.value == _internalSelectedValue;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _select(tab.value),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: _animDuration,
                          curve: _animCurve,
                          style: TextStyle(
                            color: selected ? styling.white : styling.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                          child: Text(
                            tab.label.toUpperCase(),
                            style: styling.bodyFont.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: selected ? styling.white : styling.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
