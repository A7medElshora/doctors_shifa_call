import 'package:doctors_shifa_call/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:doctors_shifa_call/core/export.dart';
import 'package:doctors_shifa_call/features/auth/presentation/screens/splash_screen/splash_screen.dart';

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
      case homeScreen:
        return MaterialPageRoute(
          builder: (_) {
            String username = '';
            String doctorId = '';
            if (arguments != null && arguments is Map<String, String>) {
              username = arguments['username'] ?? '';
              doctorId = arguments['doctorId'] ?? '';
            }
            return HomeScreen(
              username: username,
              doctorId: doctorId,
            );
          },
        );
    }

    return null;
  }
}