import 'package:flutter/material.dart';

abstract class AppColors {
  static const primaryColor = Color(0xFF4CAF50);
  static const lightAccentColor = Color(0xFF8BC34A);
  static const darkAccentColor = Color(0xFF388E3C);
  static const textColorLight = Color(0xFF212121);
  static const textColorDark = Color(0xFFF5F5F5);
  static const backgroundColorLight = Color(0xFFF5F5F5);
  static const backgroundColorDark = Color(0xFF121212);
  static const errorColor = Color(0xFFD32F2F);
  static const successColor = Color(0xFF4CAF50);
  static const warningColor = Color(0xFFFFA000);
  static const infoColor = Color(0xFF1976D2);
  static const cardColorLight = Colors.white;
  static const cardColorDark = Color(0xFF1E1E1E);
  static const borderColorLight = Color(0xFFE0E0E0);
  static const borderColorDark = Color(0xFF424242);

  static Color getAccentColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightAccentColor
        : darkAccentColor;
  }

  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? borderColorLight
        : borderColorDark;
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? backgroundColorLight
        : backgroundColorDark;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? textColorLight
        : textColorDark;
  }
}
