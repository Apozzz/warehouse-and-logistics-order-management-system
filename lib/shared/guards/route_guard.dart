import 'package:flutter/material.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/authentication/ui/pages/auth_selection_page.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/shared/services/permission_service.dart';
import 'package:inventory_system/shared/ui/pages/no_access_page.dart';
import 'package:provider/provider.dart';

class RouteGuard {
  static Route<dynamic> generateRoute(
      RouteSettings settings, WidgetBuilder builder,
      {required bool protected,
      AppPage? appPage,
      required PermissionService permissionService}) {
    if (protected && appPage != null) {
      return MaterialPageRoute(
        builder: (context) {
          final authViewModel =
              Provider.of<AuthViewModel>(context, listen: false);

          if (authViewModel.currentUser == null) {
            return const AuthSelectionPage(); // Redirect to login if not authenticated
          }

          // Directly use PermissionService without companyId and userId
          return FutureBuilder<bool>(
            future:
                permissionService.hasPermission(appPage, PermissionType.View),
            builder: (context, permissionSnapshot) {
              if (permissionSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (permissionSnapshot.hasData &&
                  permissionSnapshot.data == true) {
                return builder(context);
              } else {
                return const NoAccessPage(); // Redirect to No Access Page if permission is denied
              }
            },
          );
        },
      );
    } else {
      return MaterialPageRoute(
          builder: builder); // Unprotected routes proceed as usual
    }
  }
}
