import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/viewmodels/facebook_authentication_view_model.dart';
import 'package:provider/provider.dart';

class FacebookAuthPage extends StatelessWidget {
  const FacebookAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facebook Authentication'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final viewModel =
                Provider.of<FacebookAuthViewModel>(context, listen: false);
            viewModel.signIn();
          },
          child: const Text('Sign in with Facebook'),
        ),
      ),
    );
  }
}
