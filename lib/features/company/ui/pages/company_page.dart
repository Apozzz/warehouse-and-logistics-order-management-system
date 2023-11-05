// file: lib/features/company/ui/pages/company_selection_page.dart

import 'package:flutter/material.dart';
import 'package:inventory_system/features/company/models/company_model.dart';
import 'package:inventory_system/features/company/ui/widgets/action_buttons.dart';
import 'package:inventory_system/features/company/ui/widgets/company_list.dart';
import 'package:inventory_system/features/user/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:provider/provider.dart';

class CompanySelectionPage extends StatefulWidget {
  const CompanySelectionPage({super.key});

  @override
  _CompanySelectionPageState createState() => _CompanySelectionPageState();
}

class _CompanySelectionPageState extends State<CompanySelectionPage> {
  late Future<List<Company>> _companiesFuture;

  @override
  void initState() {
    super.initState();
    _refreshCompanies();
  }

  void _refreshCompanies() {
    setState(() {
      _companiesFuture = Provider.of<UserService>(context, listen: false)
          .getUserCompanies(FirebaseAuth.instance.currentUser!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Select or Create Company'),
      ),
      body: Column(
        children: [
          FutureBuilder<List<Company>>(
            future: _companiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No companies found');
              } else {
                return Expanded(child: CompanyList(snapshot.data!));
              }
            },
          ),
          ActionButtons(
              onRefresh:
                  _refreshCompanies), // Pass the _refreshCompanies method to ActionButtons
        ],
      ),
    );
  }
}
