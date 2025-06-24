import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;
  static const String _loginStatusKey = 'isLoggedIn';
  static const String _tokenKey = 'authToken';

  // تهيئة SharedPreferences
  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // مسح جميع البيانات من SharedPreferences
  static Future<bool> clear() async {
    return await sharedPreferences.clear();
  }

  // حفظ حالة تسجيل الدخول
  static Future<bool> setLoginStatus(bool isLoggedIn) async {
    return await sharedPreferences.setBool(_loginStatusKey, isLoggedIn);
  }

  // استرجاع حالة تسجيل الدخول
  static bool getLoginStatus() {
    return sharedPreferences.getBool(_loginStatusKey) ?? false;
  }

  // حفظ البيانات العامة
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

  // إزالة بيانات من SharedPreferences
  static Future<bool> removeData({
    required String key,
  }) async {
    return await sharedPreferences.remove(key);
  }

  // حفظ البيانات الحساسة في FlutterSecureStorage
  static Future<void> setSecureStorage({
    required String key,
    required String value,
  }) async {
    debugPrint('flutterSecureStorage setSecureStorage with key: $key and value: $value');
    const flutterSecureStorage = FlutterSecureStorage();
    await flutterSecureStorage.write(key: key, value: value);
  }

  // استرجاع البيانات الحساسة
  static Future<String?> getSecureStorage({
    required String key,
  }) async {
    const flutterSecureStorage = FlutterSecureStorage();
    return await flutterSecureStorage.read(key: key);
  }

  // حذف البيانات الحساسة
  static Future<void> deleteSecureStorage({
    required String key,
  }) async {
    debugPrint('flutterSecureStorage deleteSecureStorage with key: $key');
    const flutterSecureStorage = FlutterSecureStorage();
    await flutterSecureStorage.delete(key: key);
  }

  // حفظ الرمز المميز عند تسجيل الدخول
  static Future<void> saveToken(String token) async {
    await setSecureStorage(key: _tokenKey, value: token);
  }

  // استرجاع الرمز المميز
  static Future<String?> getToken() async {
    return await getSecureStorage(key: _tokenKey);
  }

  // مسح الرمز المميز عند تسجيل الخروج
  static Future<void> clearToken() async {
    await deleteSecureStorage(key: _tokenKey);
  }

  // دالة تسجيل الدخول
  static Future<void> login(String token) async {
    await saveToken(token);
    await setLoginStatus(true);
  }

  // دالة تسجيل الخروج
  static Future<void> logout() async {
    await clearToken();
    await setLoginStatus(false);
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

}
