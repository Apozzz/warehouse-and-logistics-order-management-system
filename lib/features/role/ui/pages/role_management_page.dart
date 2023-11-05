import 'package:flutter/material.dart';
import 'package:inventory_system/features/role/DAOs/role_dao.dart';
import 'package:inventory_system/features/role/models/role_model.dart';
import 'package:inventory_system/features/role/ui/widgets/add_role_dialog.dart';
import 'package:inventory_system/features/role/ui/widgets/delete_role_dialog.dart';
import 'package:inventory_system/features/role/ui/widgets/edit_role_dialog.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:provider/provider.dart';

class RoleManagementPage extends StatefulWidget {
  const RoleManagementPage({Key? key}) : super(key: key);

  @override
  _RoleManagementPageState createState() => _RoleManagementPageState();
}

class _RoleManagementPageState extends State<RoleManagementPage> {
  late Future<List<Role>> _rolesFuture;

  @override
  void initState() {
    super.initState();
    _rolesFuture = _fetchRoles();
  }

  Future<List<Role>> _fetchRoles() async {
    final List<Role>? roles = await withCompanyId(context, (companyId) async {
      // Once we have a companyId, fetch roles for that company.
      return await Provider.of<RoleDAO>(context, listen: false)
          .getRolesByCompanyId(companyId);
    });
    // If roles is null, we return an empty list, otherwise we return the fetched roles.
    return roles ?? [];
  }

  void _refreshRoles() {
    // Call setState to trigger a rebuild of the FutureBuilder with a new Future.
    setState(() {
      _rolesFuture = _fetchRoles();
    });
  }

  Future<void> _showEditRoleDialog(BuildContext context, Role role) async {
    final didEditRole = await showDialog<bool>(
      context: context,
      builder: (context) => EditRoleDialog(role: role),
    );
    if (didEditRole ?? false) {
      _refreshRoles();
    }
  }

  Future<void> _showDeleteRoleDialog(
      BuildContext context, String roleId) async {
    final didDeleteRole = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteRoleDialog(roleId: roleId),
    );
    if (didDeleteRole ?? false) {
      _refreshRoles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Role Management'),
      ),
      body: FutureBuilder<List<Role>>(
        future: _rolesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final roles = snapshot.data ?? [];
            return ListView.builder(
              itemCount: roles.length,
              itemBuilder: (context, index) {
                final role = roles[index];
                return ListTile(
                  title: Text(role.name),
                  subtitle:
                      Text(role.permissions.join(', ')), // Display permissions
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditRoleDialog(context, role),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _showDeleteRoleDialog(context, role.id),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Assume _showAddRoleDialog is a method that displays a dialog
          // for adding a new role and returns a boolean indicating
          // whether a new role was successfully added.
          final roleAdded = await _showAddRoleDialog(context);
          if (roleAdded) {
            // If a new role was added, refresh the list of roles.
            setState(() {
              _refreshRoles();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> _showAddRoleDialog(BuildContext context) async {
    return await withCompanyId<bool>(context, (companyId) async {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => const AddRoleDialog(),
          );
          return result ?? false;
        }) ??
        false;
  }
}
