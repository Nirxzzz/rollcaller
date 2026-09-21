// 新粗野主义 (Neo-Brutalism) 设计系统
// 特征：粗描边、硬边偏移投影（无模糊）、高饱和撞色、直角、粗体字
import 'dart:ui' show Color, Brightness;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrutalTheme {
  BrutalTheme._();

  // ---- 尺寸常量 ----
  static const double borderWidth = 2.0;
  static const double borderWidthThick = 3.0;
  static const double shadowSize = 4.0;

  // ---- 颜色常量 ----
  /// 描边/投影/正文颜色（亮色模式近黑，暗色模式米白）
  static Color ink(Brightness b) =>
      b == Brightness.light ? const Color(0xFF111111) : const Color(0xFFEFEAD8);

  /// 页面底色（亮色模式奶油黄，暗色模式深炭）
  static Color canvas(Brightness b) =>
      b == Brightness.light ? const Color(0xFFFFFBEF) : const Color(0xFF161511);

  /// 卡片/面板底色
  static Color panel(Brightness b) =>
      b == Brightness.light ? const Color(0xFFFFFFFF) : const Color(0xFF242019);

  /// 硬边偏移投影（模糊为 0，是粗野主义的签名元素）
  static BoxShadow hardShadow(Brightness b, {double? size, Color? color}) =>
      BoxShadow(
        color: color ?? ink(b),
        offset: Offset((size ?? shadowSize).w, (size ?? shadowSize).h),
        blurRadius: 0,
      );

  /// 粗野主义输入框边框
  static OutlineInputBorder border(
    Brightness b, {
    double width = borderWidth,
    Color? color,
  }) => OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: color ?? ink(b), width: width),
      );

  /// 文本主题：全部加粗
  static TextTheme textTheme(Brightness b) {
    final color = ink(b);
    return TextTheme(
      headlineLarge:
          TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w900, color: color),
      headlineMedium:
          TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w900, color: color),
      headlineSmall:
          TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: color),
      titleLarge:
          TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w800, color: color),
      titleMedium:
          TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800, color: color),
      titleSmall:
          TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: color),
      bodyLarge:
          TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, color: color),
      bodyMedium:
          TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600, color: color),
      bodySmall:
          TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: color),
      labelLarge:
          TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700, color: color),
      labelMedium:
          TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: color),
      labelSmall:
          TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: color),
    );
  }

  /// 构建新粗野主义 ThemeData
  static ThemeData build(Brightness b, Color accent) {
    ColorScheme scheme = ColorScheme.fromSeed(seedColor: accent, brightness: b)
        .copyWith(
      surface: canvas(b),
      onSurface: ink(b),
      outline: ink(b),
      shadow: ink(b),
    );

    // 亮色模式下主色用高饱和原色、文字用墨色，撞出粗野主义观感
    if (b == Brightness.light) {
      scheme = scheme.copyWith(primary: accent, onPrimary: ink(b));
    }

    final text = textTheme(b);

    return ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas(b),
      shadowColor: ink(b),
      splashFactory: NoSplash.splashFactory,
      textTheme: text,
      iconTheme: IconThemeData(color: ink(b)),
      appBarTheme: AppBarTheme(
        backgroundColor: canvas(b),
        foregroundColor: ink(b),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 26.sp,
          fontWeight: FontWeight.w900,
          color: ink(b),
        ),
      ),
      cardTheme: CardThemeData(
        color: panel(b),
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ink(b), width: borderWidth),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: panel(b),
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ink(b), width: borderWidth),
        ),
        titleTextStyle: TextStyle(
          fontSize: 26.sp,
          fontWeight: FontWeight.w900,
          color: ink(b),
        ),
        contentTextStyle: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
          color: ink(b),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.disabled)
                  ? panel(b)
                  : scheme.primary),
          foregroundColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.disabled)
                  ? ink(b).withAlpha(115)
                  : scheme.onPrimary),
          overlayColor: WidgetStatePropertyAll(ink(b).withAlpha(30)),
          elevation: const WidgetStatePropertyAll(0),
          side: WidgetStatePropertyAll(
            BorderSide(color: ink(b), width: borderWidth),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(ink(b)),
          overlayColor: WidgetStatePropertyAll(ink(b).withAlpha(30)),
          side: WidgetStatePropertyAll(
            BorderSide(color: ink(b), width: borderWidth),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(scheme.primary),
          overlayColor: WidgetStatePropertyAll(ink(b).withAlpha(30)),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: border(b),
        enabledBorder: border(b),
        focusedBorder: border(b, width: borderWidthThick),
        errorBorder: border(b, color: scheme.error),
        focusedErrorBorder: border(b, width: borderWidthThick, color: scheme.error),
        filled: true,
        fillColor: panel(b),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        labelStyle: TextStyle(color: ink(b), fontWeight: FontWeight.w700),
        hintStyle: TextStyle(color: ink(b).withAlpha(115)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: panel(b),
        contentTextStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: ink(b),
        ),
        actionTextColor: scheme.primary,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ink(b), width: borderWidth),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: canvas(b),
        selectedItemColor: ink(b),
        unselectedItemColor: ink(b).withAlpha(115),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w800),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 6.h,
        activeTrackColor: scheme.primary,
        inactiveTrackColor: ink(b).withAlpha(40),
        thumbColor: scheme.primary,
        overlayColor: Colors.transparent,
        valueIndicatorColor: ink(b),
        valueIndicatorTextStyle: TextStyle(
          color: canvas(b),
          fontWeight: FontWeight.w800,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: panel(b),
        selectedColor: scheme.primary,
        side: BorderSide(color: ink(b), width: borderWidth),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        labelStyle: TextStyle(color: ink(b), fontWeight: FontWeight.w700),
      ),
      dividerTheme: DividerThemeData(color: ink(b), thickness: 1.5),
      listTileTheme: ListTileThemeData(
        iconColor: ink(b),
        titleTextStyle: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
          color: ink(b),
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: ink(b).withAlpha(180),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ink(b), width: borderWidth),
        ),
        elevation: 0,
      ),
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: ink(b), width: borderWidth),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStatePropertyAll(ink(b)),
        trackOutlineWidth: const WidgetStatePropertyAll(borderWidth),
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary
              : panel(b),
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary.withAlpha(90)
              : panel(b),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: panel(b),
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ink(b), width: borderWidth),
        ),
        textStyle: TextStyle(color: ink(b), fontWeight: FontWeight.w600),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: ink(b).withAlpha(40),
      ),
    );
  }
}
