library extenssion_module;

import 'dart:convert';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/config/global_constant.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:fluttertoast/fluttertoast.dart';

part 'bool_extension.dart';
part 'color_extension.dart';
part 'date_time_extension.dart';
part 'list_extension.dart';
part 'map_extension.dart';
part 'number_extension.dart';
part 'string_extension.dart';
part 'widget_extension.dart';

const tagTest = '测试';
const tagHttpBegin = 'HTTP日志=====请求开始';
const tagHttpParam = 'HTTP日志=====请求参数';
const tagHttpToken = 'HTTP日志=====请求Token';
const tagHttpHead = 'HTTP日志=====请求Headers';
const tagHttpUrl = 'HTTP日志=====请求URL';
const tagHttpResponse = 'HTTP日志=====响应';
const tagHttpEnd = 'HTTP日志=====请求结束';

const bool isRelease = bool.fromEnvironment('dart.vm.product', defaultValue: false);
const bool isProfile = bool.fromEnvironment('dart.vm.profile', defaultValue: false);
const bool isDebug = !isRelease && !isProfile;

class LogUtil{

  static void log({tag = tagTest,text = ''}){
    debugPrint('$tag:$text');
  }

  static void segmentationLog(String? content){
    if(Platform.isIOS){
      log(tag: '', text: content);
    }else {
      final pattern = RegExp('.{1,800}');
      pattern.allMatches(content!).forEach((match) => log(tag: '', text: match.group(0)));
    }
  }
}
