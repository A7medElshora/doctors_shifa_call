import 'package:doctors_shifa_call/core/services/firebase/firebase_remote_config/remote_config_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

part 'intro_app_state.dart';

class IntroAppCubit extends Cubit<IntroAppState> {
  IntroAppCubit() : super(IntroAppInitial());

  Future<void> initApp() async {
    try {
      await FRConfig.instance.setupRemoteConfig();

      if (await _isForceUpdateActivated) return;

      if (_isAppUnderMaintenance) return;
    } catch (e) {
      debugPrint('GUBA :: IntroAppCubit :: initApp :: $e');
    }

    emit(NoRestriction());
  }

  Future<bool> get _isForceUpdateActivated async {
    try {
      final isUserForcedToUpdate = await FRConfig.instance.isNeedForceUpdate();
      final appLink = FRConfig.instance.appLink();
      debugPrint(
          'GUBA :: IntroAppCubit :: isUserForcedToUpdate :: $isUserForcedToUpdate');
      debugPrint('GUBA :: IntroAppCubit :: appLink :: $appLink');

      if (isUserForcedToUpdate) {
        emit(ForceUpdate(appLink: appLink));
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('GUBA :: IntroAppCubit :: _isForceUpdateActivated :: $e');
      return false;
    }
  }

  bool get _isAppUnderMaintenance {
    try {
      final isAppUnderMaintenance = FRConfig.instance.isAppUnderMaintenance;
      debugPrint(
          'GUBA :: IntroAppCubit :: isAppUnderMaintenance :: $isAppUnderMaintenance');
      if (isAppUnderMaintenance) {
        emit(AppUnderMaintenance());
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void goToStore({required String appLink}) async {
    final Uri url = Uri.parse(appLink);
    try {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Could not launch erorr  $url');
    }
  }
}
