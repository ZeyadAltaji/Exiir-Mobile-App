import 'package:flutter/material.dart';

class AppColor {
  static Color _colorFromHex(String hexColor) {
    final color = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$color', radix: 16));
  }

  static Color blue = _colorFromHex('#2944f2');
}
