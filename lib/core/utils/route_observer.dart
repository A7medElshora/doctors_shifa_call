import 'package:flutter/material.dart';

class RouteLogger extends RouteObserver {
  @override
  void didPush(Route<dynamic> route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    debugPrint('Route pushed: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    debugPrint('Route popped: ${route.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    debugPrint('Route removed: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    debugPrint(
        'Route replaced: ${oldRoute?.settings.name} with ${newRoute?.settings.name}');
  }
}
