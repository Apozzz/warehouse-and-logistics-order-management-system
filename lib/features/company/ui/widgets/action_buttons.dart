// file: lib/features/company/ui/widgets/action_buttons.dart

import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/company/ui/pages/join_company_page.dart';
import 'package:inventory_system/features/company/ui/widgets/create_company_form.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onRefresh;

  const ActionButtons({required this.onRefresh, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final company = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CompanyCreateForm(),
              ),
            );
            if (company != null) {
              onRefresh(); // Trigger the onRefresh callback if a company was created
            }
          },
          child: const Text('Create New Company'),
        ),
        const SizedBox(height: 20), // Adds some space between the buttons
        ElevatedButton(
          onPressed: () {
            // Navigate to Join Company Page
            Navigator.of(context)
                .pushReplacementNamedNoTransition(RoutePaths.joinCompany);
          },
          child: const Text('Join Existing Company'),
        ),
      ],
    );
  }
}
