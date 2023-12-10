import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inventory_system/shared/services/permission_service.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';

class PermissionControlledActionButton extends StatelessWidget {
  final AppPage appPage;
  final PermissionType permissionType;
  final Widget child;
  final VoidCallback? onPressed;

  const PermissionControlledActionButton({
    Key? key,
    required this.appPage,
    required this.permissionType,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final permissionService =
        Provider.of<PermissionService>(context, listen: false);

    return FutureBuilder<bool>(
      future: permissionService.hasPermission(appPage, permissionType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data == true) {
          // If permission is granted, return InkWell with onTap
          return InkWell(
            onTap: onPressed,
            child: child,
          );
        }
        return const SizedBox.shrink(); // Hide if permission is not granted
      },
    );
  }
}
