import 'package:flutter/material.dart';
import 'package:inventory_system/features/company/services/company_service.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:provider/provider.dart';

class CompanyJoinPage extends StatelessWidget {
  final TextEditingController _codeController = TextEditingController();

  CompanyJoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Join Existing Company'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Enter Company Code',
              ),
            ),
            ElevatedButton(
              onPressed: () => _joinCompany(context),
              child: const Text('Join Company'),
            ),
          ],
        ),
      ),
    );
  }

  void _joinCompany(BuildContext context) async {
    final companyService = Provider.of<CompanyService>(context, listen: false);
    final code = _codeController.text;
    try {
      await companyService.joinCompanyWithCode(code);
      // Optionally, navigate to a different page or show a success message
    } catch (e) {
      // Handle error, e.g., show a snackbar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join company: $e')),
      );
    }
  }
}
