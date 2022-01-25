part of extenssion_module;

extension StringUtil on String? {
  /// null或者''(空字符串)时返回true
  bool get empty => this == null || this!.isEmpty;

  /// null或者''(空字符串)或者全是空格时返回true
  bool get blank => empty || this!.trim().isEmpty;

  double get d => double.tryParse(this ?? '0') ?? 0;

  int get i => int.tryParse(this ?? '0') ?? 0;

  /// 输出控制台
  void log({String? tag}) {
    LogUtil.log(tag: tag, text: this);
  }

  /// 分段输出控制台,解决Android输出内容太长打印不全问题
  void segmentationLog() {
    LogUtil.segmentationLog(this);
  }

  String get md {
    var content = const Utf8Encoder().convert(this ?? '');
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  Color? get hexColor {
    String color = this!.replaceAll('#', '').trim();
    if (color.length == 6) {
      color = 'FF$color';
    }
    int colorValue = int.tryParse(color, radix: 16) ?? 0xFF000000;
    if (colorValue.empty) return null;
    return Color(colorValue);
  }

  /// 获取大写字母索引数组
  List<int> get upperCaseIndex {
    List<int> indexes = [];
    for (int i = 0; i < this!.codeUnits.length; i++) {
      int value = this!.codeUnits[i];
      if (value >= 65 && value <= 90) {
        indexes.add(i);
      }
    }
    return indexes;
  }

  void toast({
    pos = ToastGravity.BOTTOM,
    duration = Toast.LENGTH_SHORT,
    Color? bg,
    Color? textColor,
    size = 16.0,
    timeInSec = 1,
  }) {
    if(blank)return;
    Fluttertoast.showToast(
      msg: this ?? '',
      toastLength: duration,
      gravity: pos,
      timeInSecForIosWeb: timeInSec,
      backgroundColor: bg,
      textColor: textColor,
      fontSize: size,
    );
  }

  /// 变换字符串单词连接方式
  /// 字符串中所有大写字母变小写
  /// 根据传入[split]插入字符串单词间连接处,传入null时默认为'_',
  /// [start]为插入的首个字符
  String splitUpperCaseWith(String? start, String? split) {
    start ??= '';
    split ??= '_';
    List<int> indexes = upperCaseIndex;
    if (indexes[0] != 0) {
      indexes.insert(0, 0);
    }

    var temp = <String>[];
    for (int i = 0; i < indexes.length; i++) {
      int end = i == indexes.length - 1 ? this!.length : indexes[i + 1];
      temp.add(this!.toLowerCase().substring(indexes[i], end));
    }
    return '$start${temp.join(split)}';
  }
}
