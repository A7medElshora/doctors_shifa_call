import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// [FRConfig] is stands for Firebase Remote Config
class FRConfig {
  static final FRConfig instance = FRConfig._();
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  FRConfig._();

  /// Check Remote Config if the ['force_update'] is true, the app will navigate
  /// to force updating page, if not the app will behave normally.
  bool _isForceUpdate() {
    if (Platform.isIOS) {
      return _remoteConfig.getBool('force_update_ios');
    }
    return _remoteConfig.getBool('force_update');
  }

  String get contactUsLink {
    if (Platform.isIOS) {
      return _remoteConfig.getString('contact_us_link_ios');
    } else {
      return _remoteConfig.getString('contact_us_link');
    }
  }

  String get storeAppLink {
    if (Platform.isIOS) {
      return _remoteConfig.getString('app_link_ios');
    } else {
      return _remoteConfig.getString('app_link');
    }
  }

  /// Setup FCR configurations.

  Future<String> _getAppInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  Future<bool> _isUpdateExist() async {
    try {
      final String getAppInfo = await _getAppInfo();
      final int? buildNumber = int.tryParse(getAppInfo);
      final int configBuildNumber = Platform.isIOS
          ? _remoteConfig.getInt('build_number_ios')
          : _remoteConfig.getInt('build_number');
      debugPrint(
          'build number: $buildNumber, config build number: $configBuildNumber');
      return buildNumber != null && configBuildNumber > buildNumber;
    } catch (e) {
      debugPrint('FRConfig :: _isUpdateExist :: $e');
      return false;
    }
  }

  bool get isAppUnderMaintenance {
    // if (kDebugMode) return false;
    return _remoteConfig.getBool('is_under_maintenance');
  }

  Future<bool> isNeedForceUpdate() async {
    try {
      await setupRemoteConfig();
      final bool isUpdateExist = await _isUpdateExist();
      final bool isForceUpdateEnabled = _isForceUpdate();
      debugPrint('isUpdateExist: $isUpdateExist');
      debugPrint('isForceUpdateEnabled: $isForceUpdateEnabled');
      return isForceUpdateEnabled && isUpdateExist;
    } catch (e) {
      debugPrint('FRConfig :: isNeedForceUpdate :: $e');
      return false;
    }
  }

  Future<FirebaseRemoteConfig> setupRemoteConfig() async {
    try {
      await _remoteConfig.setDefaults(const {
        'force_update': false,
        'force_update_ios': false,
        'build_number': 0,
        'build_number_ios': 0,
        'is_under_maintenance': false,
        'app_link': 'https://play.google.com/store',
        'app_link_ios': 'https://apps.apple.com',
        'contact_us_link': 'https://play.google.com/store',
        'contact_us_link_ios': 'https://apps.apple.com',
      });
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await _remoteConfig.activate();
      await Future.delayed(const Duration(seconds: 1));
      await _remoteConfig.fetchAndActivate();
      return _remoteConfig;
    } catch (e) {
      debugPrint('FRConfig :: setupRemoteConfig :: $e');
      return _remoteConfig;
    }
  }

  String appLink() {
    debugPrint('appLinkkkkkkkkkkkkkkkkkkkkk : $storeAppLink');
    return storeAppLink;
  }
}
