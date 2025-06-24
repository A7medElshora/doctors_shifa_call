import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:doctors_shifa_call/app.dart';
import 'package:doctors_shifa_call/app_initi.dart';
import 'package:doctors_shifa_call/core/navigation/app_router.dart';
import 'package:doctors_shifa_call/core/utils/cache/cache_helper.dart';
import 'package:doctors_shifa_call/core/utils/route_observer.dart';
import 'package:doctors_shifa_call/generated/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

void main() {
  // Make zone errors fatal if you want to enforce same-zone guarantees:
  // BindingBase.debugZoneErrorsAreFatal = true;

  runZonedGuarded(() async {
    // 1. Override HTTP certificates (e.g. for development)
    HttpOverrides.global = MyHttpOverrides();

    // 2. Initialize Flutter bindings inside this zone
    WidgetsFlutterBinding.ensureInitialized();

    // 3. Redirect uncaught Flutter errors into this zone
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      logFlutterError(details);
      // Also send to Crashlytics
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };

    // 4. App-specific initialization
    await CacheHelper.init();
    await initializeApp();

    // 5. Run the app
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('ar'),
        startLocale: const Locale('ar'),
        assetLoader: const CodegenLoader(),
        child: MyApp(
          appRouter: AppRouter(),
          routeLogger: RouteLogger(),
        ),
      ),
    );
  }, (error, stackTrace) {
    // Caught by the zone guard: log and report
    logDartError(error, stackTrace);
    FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
  });
}

void logFlutterError(FlutterErrorDetails details) {
  debugPrint('E_L_S_H_O_R_A Flutter Error: ${details.exception}');
  debugPrint('E_L_S_H_O_R_A Stack trace: ${details.stack}');
}

void logDartError(Object error, StackTrace stackTrace) {
  debugPrint('E_L_S_H_O_R_A Dart Error: $error');
  debugPrint('E_L_S_H_O_R_A Stack trace: $stackTrace');
}
