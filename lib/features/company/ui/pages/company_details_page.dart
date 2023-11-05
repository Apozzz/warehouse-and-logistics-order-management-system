import 'package:flutter/material.dart';
import 'package:inventory_system/features/company/models/company_model.dart';
import 'package:inventory_system/features/company/models/tempcode_model.dart';
import 'package:inventory_system/features/company/services/company_service.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:provider/provider.dart';

class CompanyDetailsPage extends StatefulWidget {
  final Company company;

  const CompanyDetailsPage({Key? key, required this.company}) : super(key: key);

  @override
  _CompanyDetailsPageState createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  late Future<Map<String, Map<String, String>>> _userRoleNamesFuture;

  @override
  void initState() {
    super.initState();
    _userRoleNamesFuture = Provider.of<CompanyService>(context, listen: false)
        .getUserRoleNames(widget.company);
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessanger = ScaffoldMessenger.of(context);
    return BaseScaffold(
      appBar: AppBar(
        title: Text(widget.company.name),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.vpn_key),
        onPressed: () async {
          final companyService =
              Provider.of<CompanyService>(context, listen: false);
          const roleId = "..."; // replace with the role ID you want to use
          final TempCode tempCode =
              await companyService.generateTempCode(widget.company.id, roleId);
          // Optionally, display the generated code to the user:
          scaffoldMessanger.showSnackBar(
            SnackBar(content: Text('Generated code: ${tempCode.code}')),
          );
        },
      ),
      body: FutureBuilder<Map<String, Map<String, String>>>(
        future: _userRoleNamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No users found');
          } else {
            final userRoleNames = snapshot.data!;
            return ListView.builder(
              itemCount: userRoleNames.length,
              itemBuilder: (context, index) {
                final userId = userRoleNames.keys.elementAt(index);
                final userName = userRoleNames[userId]!['userName']!;
                final roleName = userRoleNames[userId]!['roleName']!;
                return ListTile(
                  title: Text('$userName - $roleName'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
