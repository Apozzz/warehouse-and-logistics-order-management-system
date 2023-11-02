import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/ui/pages/email_password_auth_page.dart';
import 'package:inventory_system/features/authentication/ui/pages/facebook_auth_page.dart';
import 'package:inventory_system/features/authentication/ui/pages/google_auth_page.dart';
import 'package:inventory_system/features/authentication/ui/pages/mobile_auth_page.dart';

class AuthSelectionPage extends StatelessWidget {
  const AuthSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Authentication Method'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EmailPasswordAuthPage()),
                );
              },
              child: const Text('Email & Password'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MobileNumberAuthPage()),
                );
              },
              child: const Text('Phone Number'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GoogleAuthPage()),
                );
              },
              child: const Text('Google'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => const FacebookAuthPage()),
            //     );
            //   },
            //   child: const Text('Facebook'),
            // ),
          ],
        ),
      ),
    );
  }
}
