part of extenssion_module;

extension DateTimeExt on DateTime {
  String shortTime() {
    DateTime now = DateTime.now();
    int value =
        (now.millisecondsSinceEpoch - millisecondsSinceEpoch) ~/ 1000;
    if (value > 60) {
      ///一小时内
      if (value < 60 * 60) {
        return "${value ~/ 60}分钟前";
      }

      ///一天内
      if (value < 60 * 60 * 24) {
        return "${value ~/ (60 * 60)}小时前";
      }

      ///三天内
      if (value < 60 * 60 * 24 * 3) {
        DateTime nowDate = DateTime(now.year, now.month, now.day);
        DateTime thisDate = DateTime(year, month, day);
        int delta = (nowDate.millisecondsSinceEpoch -
                thisDate.millisecondsSinceEpoch) ~/
            1000;

        ///同一天
        if (delta == 0) {
          return "今天";
        }
        if (delta == 60 * 60 * 24) {
          return "昨天";
        }
        if (delta == 60 * 60 * 24 * 2) {
          return "前天";
        }
      }
    } else {
      ///一分钟内
      if (value > 0) {
        return "$value秒前";
      }
      return "刚刚";
    }
    return formatDate(this, [yyyy, '-', mm, '-', dd]);
  }

  String detailTime() {
    return formatDate(
        this, [yyyy, '-', mm, '-', dd, " ", HH, ":", nn, ":", ss]);
  }
}
