// file: lib/features/company/ui/widgets/company_list.dart

import 'package:flutter/material.dart';
import 'package:inventory_system/features/company/models/company_model.dart';
import 'package:inventory_system/features/company/ui/pages/company_details_page.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
import 'package:provider/provider.dart';

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
            Provider.of<CompanyProvider>(context, listen: false).companyId =
                company.id;
            Navigator.of(context).pushReplacementNoTransition(
                CompanyDetailsPage(company: company));
          },
        );
      },
    );
  }
}
