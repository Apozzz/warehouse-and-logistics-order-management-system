import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/company/models/company_model.dart';
import 'package:inventory_system/features/company/services/company_service.dart';
import 'package:inventory_system/features/company/ui/widgets/generate_temp_code.dart';
import 'package:inventory_system/features/user/models/user_model.dart';
import 'package:inventory_system/features/user/ui/pages/user_details_form_page.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';
import 'package:provider/provider.dart';

class CompanyDetailsPage extends StatefulWidget {
  final Company company;

  const CompanyDetailsPage({Key? key, required this.company}) : super(key: key);

  @override
  _CompanyDetailsPageState createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  late Future<List<Map<String, dynamic>>> _usersWithRolesFuture;

  @override
  void initState() {
    super.initState();
    _usersWithRolesFuture = Provider.of<CompanyService>(context, listen: false)
        .getCompanyUsersWithRoles(widget.company);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: Text(widget.company.name),
      ),
      floatingActionButton: PermissionControlledActionButton(
        appPage: AppPage.CompanyDetails,
        permissionType: PermissionType.Manage,
        child: GenerateTempCode(company: widget.company),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _usersWithRolesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No users found');
          } else {
            final usersWithRoles = snapshot.data!;
            return ListView.builder(
              itemCount: usersWithRoles.length,
              itemBuilder: (context, index) {
                final userWithRole = usersWithRoles[index];
                final user = userWithRole['user'] as User;
                final roleName = userWithRole['roleName'] as String;
                return ListTile(
                  title: Text('${user.name} - $roleName'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserDetailsFormPage(user: user),
                    ));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
