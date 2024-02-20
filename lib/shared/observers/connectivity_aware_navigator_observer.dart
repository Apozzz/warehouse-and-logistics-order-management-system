import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/shared/services/connectivity_service.dart';

class ConnectivityAwareNavigatorObserver extends NavigatorObserver {
  final ConnectivityService connectivityService;

  ConnectivityAwareNavigatorObserver({required this.connectivityService}) {
    connectivityService.addListener(_onConnectivityChanged);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    // Your logic here, similar to didPush
    if (newRoute?.settings.name != null) {
      connectivityService.setLastRoute(newRoute!.settings.name!,
          arguments: newRoute.settings.arguments);
    } else if (newRoute?.settings.arguments is Widget) {
      connectivityService.setLastWidget(newRoute?.settings.arguments as Widget);
    }
  }

  void _onConnectivityChanged() async {
    if (connectivityService.connectionStatus == ConnectivityResult.none) {
      navigator?.pushNamedAndRemoveUntil(
          RoutePaths.noInternetConnection, (route) => false);
    }
  }
}
