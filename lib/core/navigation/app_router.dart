import 'package:flutter/material.dart';
import 'package:doctors_shifa_call/core/export.dart';
import 'package:doctors_shifa_call/features/auth/presentation/screens/splash_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments;

    switch (routeSettings.name) {
      case splashScreen:
        return MaterialPageRoute(
          builder: (_) {
            return const SplashScreen();
          },
        );
    }

    return null;
  }
}
