import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:provider/provider.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Logout Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final companyProvider =
                Provider.of<CompanyProvider>(context, listen: false);
            final authViewModel =
                Provider.of<AuthViewModel>(context, listen: false);
            companyProvider.setCompanyId(null);
            authViewModel.signOut();
            Navigator.of(context)
                .pushReplacementNamedNoTransition(RoutePaths.auth);
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
