import 'package:flutter/material.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/shared/guards/route_config.dart';
import 'package:inventory_system/shared/services/permission_service.dart';
import 'package:inventory_system/shared/ui/pages/no_access_page.dart';
import 'package:provider/provider.dart';

class PermissionCheckedPage extends StatelessWidget {
  final RouteConfig config;
  final Object? routeArguments;

  const PermissionCheckedPage({
    Key? key,
    required this.config,
    this.routeArguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkPermissions(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || !snapshot.data!) {
          return const NoAccessPage(); // No access if permission check fails
        }
        return _buildPage(context); // Build the page if permissions are granted
      },
    );
  }

  Future<bool> _checkPermissions(BuildContext context) {
    if (config.appPage == null) {
      return Future.value(true);
    }

    final permissionService =
        Provider.of<PermissionService>(context, listen: false);
    return permissionService.hasPermission(
        config.appPage!, PermissionType.View);
  }

  Widget _buildPage(BuildContext context) {
    if (config.builder != null) {
      return config
          .builder!(context); // Use the non-null assertion operator (!) here
    } else if (config.builderWithArgs != null) {
      return config.builderWithArgs!(context, routeArguments);
    } else {
      throw Exception('No builder defined for route ${config.path}');
    }
  }
}
