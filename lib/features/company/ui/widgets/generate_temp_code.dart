import 'package:flutter/material.dart';
import 'package:inventory_system/features/company/models/company_model.dart';
import 'package:inventory_system/features/company/services/company_service.dart';
import 'package:inventory_system/features/company/ui/widgets/role_selector.dart';
import 'package:provider/provider.dart';

class GenerateTempCode extends StatefulWidget {
  final Company company;

  const GenerateTempCode({Key? key, required this.company}) : super(key: key);

  @override
  _GenerateTempCodeState createState() => _GenerateTempCodeState();
}

class _GenerateTempCodeState extends State<GenerateTempCode> {
  void _showRoleSelectionDialog() {
    String? localSelectedRoleId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Role'),
          content: RoleSelect(
            initialRoleId: localSelectedRoleId,
            onRoleSelected: (String? roleId) {
              // This will not reset the dialog but will update the selected role ID.
              localSelectedRoleId = roleId;
              // Use StatefulBuilder to update the UI to reflect the new selection.
              (context as Element).markNeedsBuild();
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              onPressed: localSelectedRoleId != null
                  ? () {
                      Navigator.of(context).pop();
                      _generateTempCode(localSelectedRoleId!);
                    }
                  : null,
              child: const Text('Generate'),
            ),
          ],
        );
      },
    ).then((_) {
      // Clear the selected role ID after the dialog is dismissed.
      localSelectedRoleId = null;
    });
  }

  void _generateTempCode(String selectedRoleId) {
    final companyService = Provider.of<CompanyService>(context, listen: false);
    companyService
        .generateTempCode(widget.company.id, selectedRoleId)
        .then((tempCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Generated code: ${tempCode.code}')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating code: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _showRoleSelectionDialog,
      child: const Icon(Icons.vpn_key),
    );
  }
}
