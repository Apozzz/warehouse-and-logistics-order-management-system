import 'package:flutter/material.dart';
import 'package:inventory_system/features/role/DAOs/role_dao.dart';
import 'package:inventory_system/features/role/models/role_model.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class RoleSelect extends StatelessWidget {
  final Function(String?) onRoleSelected;
  final String? initialRoleId;

  const RoleSelect({
    Key? key,
    required this.onRoleSelected,
    this.initialRoleId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Role>?>(
      future: withCompanyId(
        context,
        (companyId) => Provider.of<RoleDAO>(context, listen: false)
            .getRolesByCompanyId(companyId),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No roles available.');
        } else {
          List<Role> roles = snapshot.data!;
          return DropdownButtonFormField<String>(
            value: initialRoleId,
            items: roles.map((Role role) {
              return DropdownMenuItem<String>(
                value: role.id,
                child: Text(role.name),
              );
            }).toList(),
            onChanged: onRoleSelected,
            decoration: const InputDecoration(
              labelText: 'Select Role',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null ? 'Please select a role' : null,
          );
        }
      },
    );
  }
}
