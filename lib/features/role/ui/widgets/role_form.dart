import 'package:flutter/material.dart';
import 'package:inventory_system/features/role/models/role_model.dart';
import 'package:inventory_system/features/role/ui/widgets/permission_multiselect.dart';

class RoleForm extends StatefulWidget {
  final Role? role;
  final String companyId;
  final Function(Role) onSubmit;

  const RoleForm({
    Key? key,
    required this.onSubmit,
    required this.companyId,
    this.role,
  }) : super(key: key);

  @override
  _RoleFormState createState() => _RoleFormState();
}

class _RoleFormState extends State<RoleForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  Set<Permission> selectedPermissions = <Permission>{};

  @override
  void initState() {
    super.initState();
    if (widget.role != null) {
      _nameController.text = widget.role!.name;
      selectedPermissions = widget.role!.permissions;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Role Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a role name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            PermissionMultiSelect(
              initialValue: selectedPermissions.toList(),
              onSelectionChanged: (List<Permission> newSelected) {
                setState(() {
                  selectedPermissions = Set.of(newSelected);
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newRole = Role(
                    id: widget.role?.id ?? '',
                    name: _nameController.text,
                    permissions: selectedPermissions,
                    companyId: widget.companyId,
                  );
                  widget.onSubmit(newRole);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
