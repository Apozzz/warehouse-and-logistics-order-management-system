import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/features/authentication/viewmodels/google_authentication_view_model.dart';
import 'package:provider/provider.dart';

class GoogleAuthPage extends StatelessWidget {
  const GoogleAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Authentication'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final viewModel =
                Provider.of<GoogleAuthViewModel>(context, listen: false);
            viewModel.signIn();
            await authModel.redirectToCompanyPageIfLoggedIn(context);
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
