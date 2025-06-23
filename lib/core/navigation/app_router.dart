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
            return HomeScreen(username: arguments != null && arguments is String ? arguments : '');
          },
        );
    }

    return null;
  }
}
