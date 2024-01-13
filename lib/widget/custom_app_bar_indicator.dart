import 'dart:math';

import 'package:flutter/material.dart';

class CustomTabBarIndicator extends Decoration {
  // 指示器类型
  final CustomTabBarIndicatorType type;

  // 指示器高度
  final double? height;

  // 定长下划线类型时 指示器宽度
  final double? lineWidth;

  // 指示器颜色
  final Color color;

  const CustomTabBarIndicator({
    required this.type,
    this.height,
    this.lineWidth,
    required this.color,
  });

  @override
  BoxPainter createBoxPainter([Function()? onChanged]) {
    return _CustomTabBarIndicatorPainter(
      this,
      type,
      height,
      lineWidth,
      color,
    );
  }
}

class _CustomTabBarIndicatorPainter extends BoxPainter {
  final CustomTabBarIndicator decoration;
  CustomTabBarIndicatorType type;
  double? height, lineWidth;
  Color? color;

  _CustomTabBarIndicatorPainter(
    this.decoration,
    this.type,
    this.height,
    this.lineWidth,
    this.color,
  );

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint _paint = Paint()
      ..color = color ?? _kIndicatorColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    double _height = height ?? _kIndicatorHeight;
    double _width = lineWidth ?? _kIndicatorWidth;
    switch (type) {
      case CustomTabBarIndicatorType.circle:
        canvas.drawCircle(
          Offset(
            offset.dx + (configuration.size!.width) / 2,
            configuration.size!.height - _height,
          ),
          _height,
          _paint,
        );
        break;
      case CustomTabBarIndicatorType.triangle:
        if (_height > configuration.size!.height) _height = _kIndicatorHeight;
        Path _path = Path()
          ..moveTo(
            offset.dx + (configuration.size!.width) / 2 - _height,
            configuration.size!.height,
          )
          ..lineTo(
            _height * tan(pi / 6) +
                offset.dx +
                (configuration.size!.width - _height) / 2,
            configuration.size!.height - _height,
          )
          ..lineTo(
            _height * tan(pi / 6) +
                offset.dx +
                (configuration.size!.width + _height) / 2,
            configuration.size!.height,
          );
        canvas.drawPath(_path, _paint);
        break;
      case CustomTabBarIndicatorType.rrect:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              offset.dx,
              offset.dy,
              configuration.size!.width,
              configuration.size!.height,
            ),
            const Radius.circular(_kIndicatorAngle),
          ),
          _paint,
        );
        break;
      case CustomTabBarIndicatorType.rrectInner:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              offset.dx + height!,
              height! - 1,
              configuration.size!.width - height! * 2,
              configuration.size!.height - height! * 2 - 2,
            ),
            const Radius.circular(_kIndicatorAngle),
          ),
          _paint,
        );
        break;
      case CustomTabBarIndicatorType.runderline:
        canvas.drawLine(
          Offset(offset.dx, configuration.size!.height - height! / 2),
          Offset(
            offset.dx + configuration.size!.width,
            configuration.size!.height - height! / 2,
          ),
          _paint..strokeWidth = (height! / 2),
        );
        break;
      case CustomTabBarIndicatorType.runderlineFixed:
        if (_width > configuration.size!.width) {
          _width = configuration.size!.width / 3;
        }
        canvas.drawLine(
          Offset(
            offset.dx + (configuration.size!.width - _width) / 2,
            configuration.size!.height - height! / 2,
          ),
          Offset(
            offset.dx + (configuration.size!.width + _width) / 2,
            configuration.size!.height - height! / 2,
          ),
          _paint..strokeWidth = (height! / 2),
        );
        break;
    }
  }
}

enum CustomTabBarIndicatorType {
  circle, // 实心圆点
  triangle, // 上三角
  rrect, // 圆角矩形(整个 Tab)
  rrectInner, // 圆角矩形(有内边距)
  runderline, // 圆角下划线
  runderlineFixed // 定长圆角下划线
}

// 指示器高度
const double _kIndicatorHeight = 6.0;
// 指示器宽度度
const double _kIndicatorWidth = 12.0;
// 指示器圆角
const double _kIndicatorAngle = 10.0;
// 指示器颜色
const Color _kIndicatorColor = Colors.redAccent;
