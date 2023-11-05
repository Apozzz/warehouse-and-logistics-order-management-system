import 'package:flutter/material.dart';
import 'package:inventory_system/features/role/models/role_model.dart';
import 'package:inventory_system/features/role/ui/widgets/permission_multiselect.dart';
import 'package:inventory_system/features/role/DAOs/role_dao.dart';
import 'package:provider/provider.dart';

class EditRoleDialog extends StatefulWidget {
  final Role role;

  const EditRoleDialog({Key? key, required this.role}) : super(key: key);

  @override
  _EditRoleDialogState createState() => _EditRoleDialogState();
}

class _EditRoleDialogState extends State<EditRoleDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _roleNameController;
  late Set<Permission> _selectedPermissions;

  @override
  void initState() {
    super.initState();
    _roleNameController = TextEditingController(text: widget.role.name);
    _selectedPermissions = Set.from(widget.role.permissions);
  }

  @override
  void dispose() {
    _roleNameController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final navigation = Navigator.of(context);

    if (_formKey.currentState!.validate()) {
      final roleDAO = Provider.of<RoleDAO>(context, listen: false);
      final updatedRole = Role(
        id: widget.role.id,
        name: _roleNameController.text,
        permissions: _selectedPermissions,
        companyId: widget.role.companyId,
      );

      await roleDAO.updateRole(updatedRole);
      navigation.pop(true); // Close dialog and indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Role'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _roleNameController,
                decoration: const InputDecoration(labelText: 'Role Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a role name';
                  }
                  return null;
                },
              ),
              PermissionMultiSelect(
                initialValue: List.from(_selectedPermissions),
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _selectedPermissions = Set.from(newSelection);
                  });
                },
                // Make sure to pass the appropriate colors if needed
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context)
              .pop(false), // Close dialog and indicate cancellation
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _onSubmit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
