import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/features/company/services/company_service.dart';
import 'package:provider/provider.dart';

class CompanyCreateForm extends StatefulWidget {
  const CompanyCreateForm({super.key});

  @override
  _CompanyCreateFormState createState() => _CompanyCreateFormState();
}

class _CompanyCreateFormState extends State<CompanyCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Company'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Company Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Company Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createCompany,
                child: const Text('Create Company'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createCompany() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final currentUser = authViewModel.currentUser;
      if (currentUser != null) {
        final companyService =
            Provider.of<CompanyService>(context, listen: false);
        try {
          final company = await companyService.createCompany(
            _nameController.text,
            _addressController.text,
            currentUser,
          );
          Navigator.pop(context,
              company); // Pass the created company back to the previous page
        } catch (e) {
          // Handle the error e.g., show a snackbar with the error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create company: $e')),
          );
        }
      } else {
        // Handle the case where there's no logged-in user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
