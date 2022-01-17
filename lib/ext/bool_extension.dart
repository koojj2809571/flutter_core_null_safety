part of extenssion_module;

extension BoolUtil on bool? {
  /// 非空判断包含null
  bool get empty => this == null;

  /// 调试输出控制台
  void logDebug({tag = tagTest}) {
    LogUtil.log(tag: tag, text: this);
  }

}