import 'package:flutter/material.dart';
import 'package:inventory_system/features/company/ui/widgets/create_company_form.dart';

class CompanyCreatePage extends StatelessWidget {
  const CompanyCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Company'),
      ),
      body: const CompanyCreateForm(),
    );
  }
}
