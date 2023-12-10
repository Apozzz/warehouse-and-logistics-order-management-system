import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/role/DAOs/role_dao.dart';
import 'package:inventory_system/features/role/models/role_model.dart';
import 'package:inventory_system/features/role/ui/pages/role_page.dart';
import 'package:inventory_system/features/role/ui/widgets/role_form.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:provider/provider.dart';

class EditRoleScreen extends StatefulWidget {
  final Role role;

  const EditRoleScreen({Key? key, required this.role}) : super(key: key);

  @override
  _EditRoleScreenState createState() => _EditRoleScreenState();
}

class _EditRoleScreenState extends State<EditRoleScreen> {
  late Role currentRole;

  @override
  void initState() {
    super.initState();
    currentRole = widget.role;
  }

  @override
  Widget build(BuildContext context) {
    final roleDAO = Provider.of<RoleDAO>(context, listen: false);
    final navigator = Navigator.of(context);

    return Material(
      child: RoleForm(
        role: currentRole,
        companyId: currentRole.companyId, // Pass companyId to RoleForm
        onSubmit: (updatedRole) async {
          try {
            await roleDAO.updateRole(updatedRole);
            navigator.pushReplacementNamedNoTransition(RoutePaths.roles);
          } catch (e) {
            // Handle errors (e.g., show an error message)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error updating role: ${e.toString()}')),
            );
          }
        },
      ),
    );
  }
}
