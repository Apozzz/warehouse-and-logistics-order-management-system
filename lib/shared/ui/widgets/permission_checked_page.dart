import 'package:flutter/material.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/shared/guards/route_config.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
import 'package:inventory_system/shared/services/permission_service.dart';
import 'package:inventory_system/shared/ui/pages/no_access_page.dart';
import 'package:provider/provider.dart';

class PermissionCheckedPage extends StatelessWidget {
  final RouteConfig config;

  const PermissionCheckedPage({Key? key, required this.config})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(config.isProtected);
    print(config.path);
    print(config.appPage);
    if (!config.isProtected || config.appPage == null) {
      return config
          .builder(context); // Return the page directly if it's not protected
    }

    final permissionService =
        Provider.of<PermissionService>(context, listen: false);
    final companyId =
        Provider.of<CompanyProvider>(context, listen: false).companyId;
    final userId =
        Provider.of<AuthViewModel>(context, listen: false).currentUser?.uid;

    if (userId == null || companyId == null) {
      return const NoAccessPage(); // No access if user or company ID is not available
    }

    return FutureBuilder<bool>(
      future:
          permissionService.hasPermission(config.appPage!, PermissionType.View),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data!) {
          return config
              .builder(context); // Return the page if permission is granted
        } else {
          return const NoAccessPage(); // No access page if permission is not granted
        }
      },
    );
  }
}
