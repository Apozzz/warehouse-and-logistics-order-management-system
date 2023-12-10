import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/shared/guards/route_config.dart';
import 'package:inventory_system/shared/ui/pages/not_found_page.dart';
import 'package:inventory_system/shared/ui/widgets/permission_checked_page.dart';

extension NavigatorExtensions on NavigatorState {
  Future<T?> pushReplacementNamedNoTransition<T extends Object>(
    String routeName, {
    Object? arguments,
    void Function()? onCompleted,
    State? stateReference,
  }) {
    return pushReplacement(
      PageRouteBuilder(
        settings: RouteSettings(name: routeName, arguments: arguments),
        pageBuilder: (context, animation1, animation2) {
          final routeConfig = routeConfigs.firstWhere(
            (config) => config.path == routeName,
            orElse: () => RouteConfig(
                path: RoutePaths.notFound,
                builder: (_) => const NotFoundPage()),
          );

          return PermissionCheckedPage(
              config: routeConfig); // Use the new widget
        },
        transitionDuration: const Duration(seconds: 2),
      ),
    ).then((value) {
      if (onCompleted != null && stateReference?.mounted == true) {
        onCompleted();
      }
      return value;
    });
  }

  Future<T?> pushReplacementWidgetNoTransition<T extends Object>(
    Widget screen, {
    void Function()? onCompleted,
    State? stateReference, // Pass the State reference of the calling widget
  }) {
    return pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => screen,
        transitionDuration: const Duration(seconds: 2),
      ),
    ).then((value) {
      // Call the callback if the navigation is completed and the state reference is still mounted
      if (onCompleted != null && stateReference?.mounted == true) {
        onCompleted();
      }
      return value;
    });
  }
}
