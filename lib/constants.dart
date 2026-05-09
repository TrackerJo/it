import 'package:flutter/material.dart';

enum Screens { it, players, records, me }

class TabItem {
  final String value;
  final String label;

  final IconData? icon;
  final bool isSelected;

  const TabItem({
    required this.value,
    required this.label,

    this.icon,
    this.isSelected = false,
  });
}
