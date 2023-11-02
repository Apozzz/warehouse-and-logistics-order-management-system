// file: lib/features/company/ui/widgets/company_list.dart

import 'package:flutter/material.dart';
import 'package:inventory_system/features/company/models/company_model.dart';

class CompanyList extends StatelessWidget {
  final List<Company> companies;

  const CompanyList(this.companies, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        return ListTile(
          title: Text(company.name),
          onTap: () {
            // Navigate to the selected company page
          },
        );
      },
    );
  }
}
