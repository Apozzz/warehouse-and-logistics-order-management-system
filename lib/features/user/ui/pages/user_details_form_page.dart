import 'package:flutter/material.dart';
import 'package:inventory_system/features/user/models/user_model.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:inventory_system/features/user/ui/widgets/user_details_form.dart';

class UserDetailsFormPage extends StatelessWidget {
  final User user;

  const UserDetailsFormPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Edit User Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: UserDetailsForm(user: user),
      ),
    );
  }
}
