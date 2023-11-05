import 'package:flutter/material.dart';
import 'package:inventory_system/features/role/DAOs/role_dao.dart';
import 'package:inventory_system/features/role/models/role_model.dart';
import 'package:inventory_system/features/role/ui/widgets/permission_multiselect.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class AddRoleDialogContent extends StatefulWidget {
  final String companyId;

  const AddRoleDialogContent({Key? key, required this.companyId})
      : super(key: key);

  @override
  _AddRoleDialogContentState createState() => _AddRoleDialogContentState();
}

class _AddRoleDialogContentState extends State<AddRoleDialogContent> {
  final _formKey = GlobalKey<FormState>();
  final _roleNameController = TextEditingController();
  Set<Permission> _selectedPermissions = <Permission>{};

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final roleDAO = Provider.of<RoleDAO>(context, listen: false);
      final roleName = _roleNameController.text;
      final navigator = Navigator.of(context);

      await withCompanyId(context, (companyId) async {
        try {
          await roleDAO.createRole(roleName, _selectedPermissions, companyId);
          // Handle success (e.g., close the dialog and refresh the list of roles)
          navigator.pop(true); // Close the dialog and indicate success
        } catch (e) {
          // Handle error (e.g., show a message)
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _roleNameController,
            decoration: const InputDecoration(labelText: 'Role Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a role name';
              }
              return null;
            },
          ),
          PermissionMultiSelect(
            initialValue: _selectedPermissions.toList(), // Convert Set to List
            onSelectionChanged: (selectedPermissions) {
              setState(() {
                _selectedPermissions =
                    Set.of(selectedPermissions); // Convert List to Set
              });
            },
            chipColor: Colors.black, // Specify chip color
            chipTextColor: Colors.white, // Specify chip text color
          ),
        ],
      ),
    ));
  }
}
