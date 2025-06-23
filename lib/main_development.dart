import 'dart:async';
import 'dart:developer';

import 'package:doctors_shifa_call/app.dart';
import 'package:flutter/material.dart';

import 'app_initi.dart';
import 'core/navigation/app_router.dart';
import 'core/utils/route_observer.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);

    logFlutterError(details);
  };
  runZonedGuarded(
    () async {
      await initializeApp();

      runApp(
        MyApp(
          appRouter: AppRouter(),
          routeLogger: RouteLogger(),
        ),
      );
    },
    (error, stackTrace) {
      logDartError(error, stackTrace);
      log(stackTrace.toString(), name: 'main');
      // FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

void logFlutterError(FlutterErrorDetails details) {
  debugPrint('M.a.H.m.O.u.D Flutter Error: ${details.exception}');
  debugPrint('M.a.H.m.O.u.D Stack trace: ${details.stack}');
}

void logDartError(Object error, StackTrace stackTrace) {
  debugPrint('M.a.H.m.O.u.D Dart Error: $error');
  debugPrint('M.a.H.m.O.u.D Stack trace: $stackTrace');
}
