import 'package:flutter/material.dart';
import 'package:inventory_system/features/role/ui/widgets/add_role_dialog_content.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';

class AddRoleDialog extends StatelessWidget {
  const AddRoleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: withCompanyId(context, (companyId) async {
        return companyId; // return the companyId
      }),
      builder: (context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return a loader or an empty Container while waiting
          return Container();
        } else if (snapshot.hasError) {
          // handle error, e.g., return an error dialog or message
          return AlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final companyId = snapshot.data!;
          return AlertDialog(
            title: const Text('Add Role'),
            content: AddRoleDialogContent(companyId: companyId),
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
                  // Assume _onSubmit is a method defined within AddRoleDialogContent
                  // that handles form submission
                  // AddRoleDialogContentState._onSubmit();
                  // The above line won't work directly, you may need to setup a callback or use a state management solution
                },
                child: const Text('Add'),
              ),
            ],
          );
        } else {
          // handle null companyId or other scenarios
          return const AlertDialog(
            title: Text('Error'),
            content: Text('Company ID is null'),
          );
        }
      },
    );
  }
}
