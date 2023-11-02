// file: lib/features/company/ui/widgets/action_buttons.dart

import 'package:flutter/material.dart';
import 'package:inventory_system/features/company/ui/pages/join_company_page.dart';
import 'package:inventory_system/features/company/ui/widgets/create_company_form.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Navigate to Create Company Page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CompanyCreateForm(),
              ),
            );
          },
          child: const Text('Create New Company'),
        ),
        const SizedBox(height: 20), // Adds some space between the buttons
        ElevatedButton(
          onPressed: () {
            // Navigate to Join Company Page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompanyJoinPage(),
              ),
            );
          },
          child: const Text('Join Existing Company'),
        ),
      ],
    );
  }
}
