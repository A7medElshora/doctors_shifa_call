import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  // ignore: always_declare_return_types
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> clear() async {
    return await sharedPreferences.clear();
  }

  static Future<bool> putBool({
    required String key,
    required bool value,
  }) async {
    return await sharedPreferences.setBool(key, value);
  }

  static String getString({
    required String key,
  }) {
    return sharedPreferences.getString(key) ?? '';
  }

  static int getInteger({
    required String key,
  }) {
    return sharedPreferences.getInt(key) ?? 0;
  }

  static bool getBool({required String key}) {
    return sharedPreferences.getBool(key) ?? false;
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else {
      return await sharedPreferences.setDouble(key, value);
    }
  }

  static Future<bool> removeData({
    required String key,
  }) async {
    return await sharedPreferences.remove(key);
  }

  // set secured string
  static setSecureStorge({
    required String key,
    required String value,
  }) async {
    debugPrint('flutterSecureStorage setSecureStorge with key : $key and value : $value');
    const flutterSecureStorage = FlutterSecureStorage();
    await flutterSecureStorage.write(key: key, value: value);
  }

  // get secured string
  static Future<String?> getSecureStorge({
    required String key,
  }) async {
    
    const flutterSecureStorage = FlutterSecureStorage();
    return await flutterSecureStorage.read(key: key) ?? '';
  }

  // delete secured string
  static deleteSecureStorge({
    required String key,
  }) async {
    debugPrint('flutterSecureStorage deleteSecureStorge with key : $key');
    const flutterSecureStorage = FlutterSecureStorage();
    await flutterSecureStorage.delete(key: key);
  }
}
