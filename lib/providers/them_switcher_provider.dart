import 'package:flutter/material.dart'
    show Brightness, ChangeNotifier, ThemeData, ThemeMode;

import '../configs/brutal_theme.dart';
import '../configs/theme_style_option_enum.dart';

class ThemeSwitcherProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeStyleOption _themeStyle = ThemeStyleOption.blue;

  ThemeMode get themeMode => _themeMode;
  ThemeStyleOption get themeStyle => _themeStyle;

  ThemeData? get theme =>
      _themeDataMap[_themeStyle]![Brightness.light];
  ThemeData? get darkTheme =>
      _themeDataMap[_themeStyle]![Brightness.dark];

  // 新粗野主义主题数据：每种风格只有主色不同
  static final Map<ThemeStyleOption, Map<Brightness, ThemeData>> _themeDataMap =
      {
    for (final style in ThemeStyleOption.values)
      style: {
        Brightness.light: BrutalTheme.build(Brightness.light, style.color),
        Brightness.dark: BrutalTheme.build(Brightness.dark, style.color),
      },
  };

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  void setThemeStyle(ThemeStyleOption themeStyle) {
    _themeStyle = themeStyle;
    if (themeStyle == ThemeStyleOption.diy) {
      _updateDiyThemeData();
    }
    notifyListeners();
  }

  void _updateDiyThemeData() {
    _themeDataMap[ThemeStyleOption.diy] = {
      Brightness.light:
          BrutalTheme.build(Brightness.light, ThemeStyleOption.diy.color),
      Brightness.dark:
          BrutalTheme.build(Brightness.dark, ThemeStyleOption.diy.color),
    };
  }

  void setModelAndStyle(ThemeMode themeMode, ThemeStyleOption themeStyle) {
    _themeMode = themeMode;
    _themeStyle = themeStyle;
    if (themeStyle == ThemeStyleOption.diy) {
      _updateDiyThemeData();
    }

    notifyListeners();
  }

  void setModelAndStyleWithoutNotify(ThemeMode themeMode, ThemeStyleOption themeStyle) {
    _themeMode = themeMode;
    _themeStyle = themeStyle;
    if (themeStyle == ThemeStyleOption.diy) {
      _updateDiyThemeData();
    }
  }
}
