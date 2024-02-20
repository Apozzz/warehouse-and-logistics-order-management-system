import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/ui/pages/auth_selection_page.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/shared/guards/route_config.dart';
import 'package:inventory_system/shared/models/view_permissions.dart';
import 'package:inventory_system/shared/services/permission_service.dart';
import 'package:inventory_system/shared/ui/pages/no_access_page.dart';
import 'package:provider/provider.dart';

class RouteGuard {
  static Route<dynamic> generateRoute(RouteSettings settings,
      {required bool protected,
      required RouteConfig routeConfig,
      required PermissionService permissionService}) {
    WidgetBuilder builder = _getBuilder(routeConfig, settings);

    if (protected && routeConfig.appPage != null) {
      return MaterialPageRoute(
        builder: (context) {
          final authViewModel =
              Provider.of<AuthViewModel>(context, listen: false);

          if (authViewModel.currentUser == null) {
            return const AuthSelectionPage(); // Redirect to login if not authenticated
          }

          // Directly use PermissionService without companyId and userId
          return FutureBuilder<ViewPermissions>(
            future:
                permissionService.fetchViewPermissions(routeConfig.appPage!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData ||
                  (!snapshot.data!.viewSelf && !snapshot.data!.viewAll)) {
                return const NoAccessPage(); // No access if no view permission
              }

              return builder(context);
            },
          );
        },
      );
    } else {
      return MaterialPageRoute(
          builder: builder); // Unprotected routes proceed as usual
    }
  }

  static WidgetBuilder _getBuilder(
      RouteConfig routeConfig, RouteSettings settings) {
    // This function selects the appropriate builder based on the routeConfig
    return (BuildContext context) {
      if (routeConfig.builderWithArgs != null) {
        return routeConfig.builderWithArgs!(context, settings.arguments);
      } else if (routeConfig.builder != null) {
        return routeConfig.builder!(context);
      } else {
        throw Exception('No builder defined for route ${routeConfig.path}');
      }
    };
  }
}
