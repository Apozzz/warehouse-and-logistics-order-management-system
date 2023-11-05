import 'package:flutter/material.dart';
import 'package:inventory_system/features/company/ui/widgets/create_company_form.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';

class CompanyCreatePage extends StatelessWidget {
  const CompanyCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Create Company'),
      ),
      body: const CompanyCreateForm(),
    );
  }
}
