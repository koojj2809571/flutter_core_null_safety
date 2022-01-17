import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储
class StorageUtil {
  static final StorageUtil _instance = StorageUtil._();
  factory StorageUtil() => _instance;
  late SharedPreferences _prefs;

  StorageUtil._();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    return _prefs.setString(key, jsonString);
  }

  dynamic getJSON(String key) {
    String? jsonString = _prefs.getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  Future<bool> setBool(String key, bool val) {
    return _prefs.setBool(key, val);
  }

  bool getBool(String key) {
    bool? val = _prefs.getBool(key);
    return val ?? false;
  }

  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }
}
