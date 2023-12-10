import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/role/DAOs/role_dao.dart';
import 'package:inventory_system/features/role/models/role_model.dart';
import 'package:inventory_system/features/role/ui/widgets/edit_role.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';
import 'package:provider/provider.dart';

class RoleList extends StatefulWidget {
  const RoleList({Key? key}) : super(key: key);

  @override
  _RoleListState createState() => _RoleListState();
}

class _RoleListState extends State<RoleList> {
  late Future<List<Role>> rolesFuture;

  @override
  void initState() {
    super.initState();
    fetchRolesWithCompanyId();
  }

  Future<void> fetchRolesWithCompanyId() async {
    withCompanyId(context, (companyId) async {
      final roleDAO = Provider.of<RoleDAO>(context, listen: false);
      rolesFuture = roleDAO.getRolesByCompanyId(companyId);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return FutureBuilder(
      future: rolesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || (snapshot.data as List<Role>).isEmpty) {
          return const Center(child: Text('No roles found.'));
        } else {
          List<Role> roles = snapshot.data as List<Role>;
          return ListView.separated(
            itemCount: roles.length,
            itemBuilder: (context, index) {
              final role = roles[index];
              return ListTile(
                title: Text(role.name),
                subtitle: Text(
                  'Permissions: ${_getAppliedPermissions(role)}',
                ),
                trailing: PermissionControlledActionButton(
                  appPage:
                      AppPage.Roles, // Specify the AppPage for the delivery
                  permissionType: PermissionType.Manage,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          navigator
                              .pushReplacementWidgetNoTransition(
                                  EditRoleScreen(role: role))
                              .then((_) {
                            fetchRolesWithCompanyId(); // Refresh the list after returning from the edit screen
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete Role'),
                                content: Text(
                                    'Are you sure you want to delete the role ${role.name}?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      withCompanyId(context, (companyId) async {
                                        final roleDAO = Provider.of<RoleDAO>(
                                            context,
                                            listen: false);
                                        await roleDAO.deleteRole(role.id);
                                        navigator.pop();
                                        fetchRolesWithCompanyId(); // Refresh
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        }
      },
    );
  }

  String _getAppliedPermissions(Role role) {
    List<String> appliedPermissions = [];
    for (var rp in role.rolePermissions) {
      for (var type in rp.permissions.keys) {
        if (rp.permissions[type] == true) {
          appliedPermissions.add('${rp.page.name} (${type.name})');
        }
      }
    }
    return appliedPermissions.join(', ');
  }
}
