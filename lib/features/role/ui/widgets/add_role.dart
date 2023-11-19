import 'package:flutter/material.dart';
import 'package:inventory_system/features/role/DAOs/role_dao.dart';
import 'package:inventory_system/features/role/ui/pages/role_page.dart';
import 'package:inventory_system/features/role/ui/widgets/role_form.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class AddRoleForm extends StatefulWidget {
  const AddRoleForm({Key? key}) : super(key: key);

  @override
  _AddRoleFormState createState() => _AddRoleFormState();
}

class _AddRoleFormState extends State<AddRoleForm> {
  String? companyId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch the companyId
      companyId = await withCompanyId<String>(context, (id) async {
        return id; // Return the companyId to be used in the state
      });
    } finally {
      // Ensures the UI is rebuilt with new data or error message
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleDAO = Provider.of<RoleDAO>(context, listen: false);
    final navigator = Navigator.of(context);

    if (isLoading) {
      return const CircularProgressIndicator();
    }

    if (companyId == null) {
      return const Text('Company ID is missing.');
    }

    return RoleForm(
      companyId: companyId!,
      onSubmit: (role) async {
        try {
          await roleDAO.createRole(role.name, role.permissions, companyId!);
          navigator.pushReplacementNoTransition(const RolePage());
        } catch (e) {
          // Handle errors (e.g., show an error message)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding role: ${e.toString()}')),
          );
        }
      },
    );
  }
}
