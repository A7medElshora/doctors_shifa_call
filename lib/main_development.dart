import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:doctors_shifa_call/app.dart';
import 'package:doctors_shifa_call/app_initi.dart';
import 'package:doctors_shifa_call/generated/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'core/navigation/app_router.dart';
import 'core/utils/route_observer.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    logFlutterError(details);
  };

  HttpOverrides.global = MyHttpOverrides();

  runZonedGuarded(
    () async {
      await initializeApp();
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
    },
    (error, stackTrace) {
      logDartError(error, stackTrace);
      log(stackTrace.toString(), name: 'main_dev');
    },
  );
}

void logFlutterError(FlutterErrorDetails details) {
  debugPrint('E_L_S_H_O_R_A Flutter Error: ${details.exception}');
  debugPrint('E_L_S_H_O_R_A Stack trace: ${details.stack}');
}

void logDartError(Object error, StackTrace stackTrace) {
  debugPrint('E_L_S_H_O_R_A Dart Error: $error');
  debugPrint('E_L_S_H_O_R_A Stack trace: $stackTrace');
}