import 'package:flutter/cupertino.dart';

typedef CheckLogin = bool Function();

class GlobalConstant {
  static GlobalConstant? _instance;

  late final CheckLogin _checkLogin;

  late final BuildContext _app;

  late final String _emptyDataBg;

  late final String _errorBg;

  late final String _loadingBg;

  factory GlobalConstant() {
    _instance ??= GlobalConstant._();
    return _instance!;
  }

  GlobalConstant._();

  void init({
    required CheckLogin checkLogin,
    required BuildContext app,
    String? emptyDataBg,
    String? errorBg,
    String? loadingBg,
  }){
    _checkLogin = checkLogin;
    _app = app;
    _emptyDataBg = emptyDataBg ?? '';
    _errorBg = errorBg ?? '';
    _loadingBg = loadingBg ?? '';
  }

  CheckLogin get checkLogin => _checkLogin;
  BuildContext get app => _app;
  String get emptyDataBg => _emptyDataBg;
  String get errorBg => _errorBg;
  String get loadingBg => _loadingBg;
}
