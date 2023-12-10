import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/role/ui/widgets/add_role.dart';
import 'package:inventory_system/features/role/ui/widgets/role_list.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';

class RolePage extends StatelessWidget {
  const RolePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Roles'),
      ),
      body: const RoleList(),
      floatingActionButton: PermissionControlledActionButton(
        appPage: AppPage.Roles, // Specify the AppPage for the delivery
        permissionType: PermissionType.Manage,
        child: FloatingActionButton(
          onPressed: () {
            _showAddRoleForm(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddRoleForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const Material(
            child: AddRoleForm(), // Your form widget for adding roles
          ),
        );
      },
    );
  }
}
