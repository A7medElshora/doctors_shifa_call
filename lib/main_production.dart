import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:doctors_shifa_call/app.dart';
import 'package:doctors_shifa_call/app_initi.dart';
import 'package:doctors_shifa_call/generated/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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

Future<void> main() async {
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
    (error, stack) {
      log(stack.toString(), name: 'main production error');
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}
