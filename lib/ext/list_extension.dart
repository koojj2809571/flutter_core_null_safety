part of extenssion_module;

extension ListUtil on List? {
  /// 非空判断包含null
  bool get empty => this == null || this!.isEmpty;

  /// 转日志用字符串输出
  String listToStructureString({int indentation = 2}) {
    String result = "";
    String indentationStr = " " * indentation;
    result += "$indentationStr[";
    if (this!.isNotEmpty) {
      for (var value in this!) {
        if (value is Map) {
          var temp = value.mapToStructureString(indentation: indentation + 2);
          result += "\n$indentationStr$temp,";
        } else if (value is List) {
          result += value.listToStructureString(indentation: indentation + 2);
        } else {
          String temp = (value is String) ? "\"$value\"," : "$value,";
          result += "\n$indentationStr" + temp;
        }
      }
      result = result.substring(0, result.length - 1);
    }
    result += "\n$indentationStr]";

    return result;
  }

  /// 输出控制台
  void log({String? tag}) {
    LogUtil.log(tag: tag, text: this);
  }

  /// 分段输出控制台,解决Android输出内容太长打印不全问题
  void segmentationLog() {
    LogUtil.segmentationLog(toString());
  }
}