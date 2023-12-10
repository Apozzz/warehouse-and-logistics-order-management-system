import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
import 'package:provider/provider.dart';

class AuthenticatedAction extends StatelessWidget {
  final Function(BuildContext context, String companyId, [String? userId])
      action;
  final bool requireUser; // Add this flag to determine if user is required

  const AuthenticatedAction({
    Key? key,
    required this.action,
    this.requireUser = false, // default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getCompanyId(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No company ID available');
        } else {
          final companyId = snapshot.data!;
          final userId = requireUser
              ? context.read<AuthViewModel>().currentUser?.uid
              : null;

          if (!requireUser || userId != null) {
            action(context, companyId, userId);
          } else {
            return const Text('User not logged in');
          }
          return Container();
        }
      },
    );
  }

  Future<String> getCompanyId(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    return Provider.of<CompanyProvider>(context, listen: false).companyId ?? '';
  }
}
