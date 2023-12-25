// file: lib/features/company/ui/widgets/company_list.dart

import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/category/services/category_service.dart';
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
          onTap: () async {
            final companyProvider =
                Provider.of<CompanyProvider>(context, listen: false);
            final categoryService =
                Provider.of<CategoryService>(context, listen: false);
            await companyProvider.setCompanyId(
                company.id); // Set the companyId and fetch details

            if (companyProvider.company != null) {
              await categoryService
                  .initializeCategories(companyProvider.company!.id);
              Navigator.of(context)
                  .pushReplacementNamedNoTransition(RoutePaths.home);
            } else {
              // Handle the case where company details couldn't be fetched
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load company details')),
              );
            }
          },
        );
      },
    );
  }
}
