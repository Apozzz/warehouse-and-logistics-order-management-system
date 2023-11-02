import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/viewmodels/mobile_number_authentication_view_model.dart';
import 'package:provider/provider.dart';

class MobileNumberAuthPage extends StatefulWidget {
  const MobileNumberAuthPage({Key? key}) : super(key: key);

  @override
  _MobileNumberAuthPageState createState() => _MobileNumberAuthPageState();
}

class _MobileNumberAuthPageState extends State<MobileNumberAuthPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  bool _verificationCodeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Number Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_verificationCodeSent) ...[
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              ElevatedButton(
                onPressed: () {
                  final viewModel = Provider.of<MobileNumberAuthViewModel>(
                      context,
                      listen: false);
                  viewModel.verifyPhoneNumber(
                      _phoneNumberController.text, context);
                  setState(() {
                    _verificationCodeSent = true;
                  });
                },
                child: const Text('Verify Phone Number'),
              ),
            ] else ...[
              TextField(
                controller: _verificationCodeController,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  final viewModel = Provider.of<MobileNumberAuthViewModel>(
                      context,
                      listen: false);
                  viewModel.verifyCode(_verificationCodeController.text);
                },
                child: const Text('Submit Verification Code'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
