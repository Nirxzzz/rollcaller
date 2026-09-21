// 新粗野主义通用组件
// BrutalBox：粗描边 + 硬边偏移投影容器
// BrutalButton：按下时位移「吃掉」投影的实体按钮
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../configs/brutal_theme.dart';

/// 粗野主义容器：直角、粗描边、硬边偏移投影
class BrutalBox extends StatelessWidget {
  const BrutalBox({
    super.key,
    required this.child,
    this.color,
    this.borderColor,
    this.shadowSize,
    this.padding,
    this.margin,
  });

  final Widget child;
  final Color? color;
  final Color? borderColor;
  final double? shadowSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final edge = borderColor ?? Theme.of(context).colorScheme.outline;
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? BrutalTheme.panel(b),
        border: Border.all(color: edge, width: BrutalTheme.borderWidth),
        boxShadow: [BrutalTheme.hardShadow(b, size: shadowSize, color: edge)],
      ),
      child: child,
    );
  }
}

/// 粗野主义按钮：按下后向投影方向位移，投影消失，产生「按进纸面」的效果
class BrutalButton extends StatefulWidget {
  const BrutalButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.foregroundColor,
    this.fontSize,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? foregroundColor;
  final double? fontSize;
  final bool expand;

  @override
  State<BrutalButton> createState() => _BrutalButtonState();
}

class _BrutalButtonState extends State<BrutalButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final scheme = Theme.of(context).colorScheme;
    final enabled = widget.onPressed != null;
    final bg = enabled
        ? (widget.color ?? scheme.primary)
        : BrutalTheme.panel(b);
    final fg = enabled
        ? (widget.foregroundColor ?? scheme.onPrimary)
        : scheme.outline.withAlpha(115);
    final edge = scheme.outline;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: widget.fontSize ?? 24.sp, color: fg),
          SizedBox(width: 8.w),
        ],
        Flexible(
          child: Text(
            widget.label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: widget.fontSize ?? 24.sp,
              fontWeight: FontWeight.w800,
              color: fg,
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: widget.expand ? double.infinity : null,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        alignment: Alignment.center,
        transform: Matrix4.translationValues(
          _pressed ? BrutalTheme.shadowSize.w : 0,
          _pressed ? BrutalTheme.shadowSize.h : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: edge, width: BrutalTheme.borderWidth),
          boxShadow: _pressed || !enabled
              ? const []
              : [
                  BoxShadow(
                    color: edge,
                    offset: Offset(
                      BrutalTheme.shadowSize.w,
                      BrutalTheme.shadowSize.h,
                    ),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: content,
      ),
    );
  }
}
