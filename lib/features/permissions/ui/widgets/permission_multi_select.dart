import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/permissions/models/role_permission_model.dart';

// Assuming Page and PermissionType enums are defined as above

class PermissionMultiSelect extends StatefulWidget {
  final List<RolePermission> initialPermissions;
  final ValueChanged<List<RolePermission>> onSelectionChanged;

  const PermissionMultiSelect({
    Key? key,
    required this.initialPermissions,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _PermissionMultiSelectState createState() => _PermissionMultiSelectState();
}

class _PermissionMultiSelectState extends State<PermissionMultiSelect> {
  late List<RolePermission> permissions;

  @override
  void initState() {
    super.initState();
    permissions = widget.initialPermissions.isNotEmpty
        ? widget.initialPermissions
        : _getDefaultRolePermissions();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: permissions.map((rolePermission) {
          return Card(
            child: ExpansionTile(
              title: Text(rolePermission.page.name), // Using the 'name' getter
              children: PermissionType.values.map((type) {
                bool isSelected = rolePermission.permissions[type] ?? false;
                return CheckboxListTile(
                  title: Text(type.name), // Using the 'name' getter
                  value: isSelected,
                  onChanged: (bool? selected) {
                    setState(() {
                      // Create a new RolePermission with updated permissions
                      final updatedPermissions = Map<PermissionType, bool>.from(
                          rolePermission.permissions)
                        ..[type] = selected ?? false;
                      final updatedRolePermission = RolePermission(
                        page: rolePermission.page,
                        permissions: updatedPermissions,
                      );

                      // Replace the old RolePermission with the updated one
                      permissions = [
                        for (final perm in permissions)
                          if (perm.page == updatedRolePermission.page)
                            updatedRolePermission
                          else
                            perm
                      ];

                      widget.onSelectionChanged(permissions);
                    });
                  },
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<RolePermission> _getDefaultRolePermissions() {
    return AppPage.values.map((page) {
      return RolePermission(
        page: page,
        permissions: {for (var type in PermissionType.values) type: false},
      );
    }).toList();
  }
}
