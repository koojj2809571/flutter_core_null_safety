part of extenssion_module;

/// widget 扩展
extension WidgetExt on Widget {
  GestureDetector intoGesture({
    bool needLogin = false,
    GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
  }) =>
      GestureDetector(
        child: this,
        onTap: () {
          bool isLogin = needLogin ? GlobalConstant().checkLogin() : true;
          if (onTap != null && isLogin) {
            onTap();
          }
        },
        onDoubleTap: () {
          bool isLogin = needLogin ? GlobalConstant().checkLogin() : true;
          if (onDoubleTap != null && isLogin) {
            onDoubleTap();
          }
        },
        onLongPress: () {
          bool isLogin = needLogin ? GlobalConstant().checkLogin() : true;
          if (onLongPress != null && isLogin) {
            onLongPress();
          }
        },
        behavior: HitTestBehavior.translucent,
      );

  Expanded intoExpand({flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }
}
