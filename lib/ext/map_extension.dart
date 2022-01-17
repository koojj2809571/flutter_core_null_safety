part of extenssion_module;

extension MapUtil on Map? {
  /// 非空判断包含null
  bool get empty => this == null || this!.isEmpty;

  /// 转日志用字符串输出
  String mapToStructureString({int indentation = 2}) {
    String result = "";
    String indentationStr = " " * indentation;
    result += "{";
    if (this!.isNotEmpty) {
      this!.forEach((key, value) {
        if (value is Map) {
          var temp = value.mapToStructureString(indentation: indentation + 2);
          result += "\n$indentationStr\"$key\" : $temp,";
        } else if (value is List) {
          result += "\n$indentationStr\"$key\" : ${value.listToStructureString(indentation: indentation + 2)},";
        } else {
          String temp = (value is String) ? "\"$value\"," : "$value,";
          result += "\n$indentationStr\"$key\" : " + temp;
        }
      });
      result = result.substring(0, result.length - 1);
    }
    result += indentation == 2 ? "\n}" : "\n${" " * (indentation - 1)}}";

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