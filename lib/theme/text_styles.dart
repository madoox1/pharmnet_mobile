import 'package:flutter/material.dart';

class AppTextStyles {
  static const Color _textColor = Color(0xFF1D1B20);

  static const TextStyle baseStyle = TextStyle(
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.4,
    leadingDistribution: TextLeadingDistribution.even,
    textBaseline: TextBaseline.alphabetic,
    decoration: TextDecoration.none,
    color: _textColor,
  );

  static TextStyle get bodyText => baseStyle.copyWith(fontSize: 14);
  static TextStyle get emailText => baseStyle.copyWith(fontSize: 16);
  static TextStyle get headingText => baseStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      );
}
