// Theme style option enum
import 'dart:ui' show Color;

import 'package:flutter/material.dart' show Colors, ThemeMode;

import '../l10n/generated/app_localizations.dart';

enum ThemeStyleOption { red, orange, yellow, green, blue, indigo, purple, diy }

extension ThemeStyleOptionExtension on ThemeStyleOption {

  static Color pickedColor = Colors.white;
  String displayName(AppLocalizations l10n) {
    switch (this) {
      case ThemeStyleOption.red:
        return l10n.themeColorRed;
      case ThemeStyleOption.orange:
        return l10n.themeColorOrange;
      case ThemeStyleOption.yellow:
        return l10n.themeColorYellow;
      case ThemeStyleOption.green:
        return l10n.themeColorGreen;
      case ThemeStyleOption.blue:
        return l10n.themeColorBlue;
      case ThemeStyleOption.indigo:
        return l10n.themeColorIndigo;
      case ThemeStyleOption.purple:
        return l10n.themeColorPurple;
      case ThemeStyleOption.diy:
        return l10n.themeColorCustom;
    }
  }

  Color get color {
    switch (this) {
      case ThemeStyleOption.red:
        return Colors.red;
      case ThemeStyleOption.orange:
        return Colors.orange;
      case ThemeStyleOption.yellow:
        return Colors.yellow;
      case ThemeStyleOption.green:
        return Colors.green;
      case ThemeStyleOption.blue:
        return Colors.blue;
      case ThemeStyleOption.indigo:
        return Colors.indigo;
      case ThemeStyleOption.purple:
        return Colors.purple;
      case ThemeStyleOption.diy:
        return pickedColor;
    }
  }

  static ThemeStyleOption fromString(String? value) {
    switch (value) {
      case 'ThemeStyleOption.red':
        return ThemeStyleOption.red;
      case 'ThemeStyleOption.orange':
        return ThemeStyleOption.orange;
      case 'ThemeStyleOption.yellow':
        return ThemeStyleOption.yellow;
      case 'ThemeStyleOption.green':
        return ThemeStyleOption.green;
      case 'ThemeStyleOption.blue':
        return ThemeStyleOption.blue;
      case 'ThemeStyleOption.indigo':
        return ThemeStyleOption.indigo;
      case 'ThemeStyleOption.purple':
        return ThemeStyleOption.purple;
      case 'ThemeStyleOption.diy':
        return ThemeStyleOption.diy;
      default:
        return ThemeStyleOption.blue;
    }
  }

  static ThemeMode fromStringToThemeMode(String value) {
    switch (value) {
      case 'ThemeMode.system':
        return ThemeMode.system;
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static Color getContrastColor(Color color) {
    double brightness =
        0.299 * (color.r * 255.0).round().clamp(0, 255) +
        0.587 * (color.g * 255.0).round().clamp(0, 255) +
        0.114 * (color.b * 255.0).round().clamp(0, 255);
    return brightness > 128 ? Colors.black : Colors.white;
  }
}
