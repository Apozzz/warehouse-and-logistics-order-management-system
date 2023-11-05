import 'package:flutter/material.dart';
import 'package:inventory_system/features/role/DAOs/role_dao.dart';
import 'package:provider/provider.dart';

class DeleteRoleDialog extends StatelessWidget {
  final String roleId;

  const DeleteRoleDialog({Key? key, required this.roleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Role'),
      content: const Text('Are you sure you want to delete this role?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pop(false); // Close dialog and indicate cancellation
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Call RoleDAO.deleteRole to delete the role, then close the dialog
            final roleDAO = Provider.of<RoleDAO>(context, listen: false);
            roleDAO.deleteRole(roleId).then((_) {
              Navigator.of(context)
                  .pop(true); // Close dialog and indicate success
            });
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
