library net_module;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/ext/extension_module.dart';

part 'interceptor/change_base_url.dart';
part 'interceptor/http_log.dart';
part 'interceptor/connection_status.dart';
part 'http_util.dart';
part 'http_controller.dart';

const extraLogRequest = 'extra_log_request';
const extraLogResponse = 'extra_log_response'; // 包含error打印也有这个flag控制

const extraRefresh = 'extra_refresh';
const extraCache = 'extra_cache';