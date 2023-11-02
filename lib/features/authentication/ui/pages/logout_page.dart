import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:provider/provider.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final authViewModel =
                Provider.of<AuthViewModel>(context, listen: false);
            authViewModel.signOut();
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
