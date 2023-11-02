import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/viewmodels/email_password_authentication_view_model.dart';
import 'package:provider/provider.dart';

class EmailPasswordAuthPage extends StatelessWidget {
  const EmailPasswordAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EmailPasswordAuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email & Password Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: viewModel.updateEmail,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: viewModel.updatePassword,
            ),
            ElevatedButton(
              onPressed: viewModel.signIn,
              child: const Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: viewModel.signUp,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
