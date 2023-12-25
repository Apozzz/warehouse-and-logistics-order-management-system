import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/company/models/company_model.dart';
import 'package:inventory_system/features/company/services/company_service.dart';
import 'package:inventory_system/features/company/ui/widgets/generate_temp_code.dart';
import 'package:inventory_system/features/user/DAOs/user_dao.dart';
import 'package:inventory_system/features/user/models/user_model.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
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
                  trailing: roleName != 'CEO'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PermissionControlledActionButton(
                              appPage: AppPage
                                  .Users, // Assuming you have a Users AppPage
                              permissionType: PermissionType.Manage,
                              child: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamedNoTransition(
                                    RoutePaths.userDetails,
                                    arguments: user,
                                  );
                                },
                              ),
                            ),
                            PermissionControlledActionButton(
                              appPage: AppPage
                                  .Users, // Assuming you have a Users AppPage
                              permissionType: PermissionType.Manage,
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Delete User'),
                                        content: Text(
                                            'Are you sure you want to delete ${user.name}?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.of(
                                                    context)
                                                .pop(), // Dismiss the dialog
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              withCompanyId(context,
                                                  (companyId) async {
                                                final userService =
                                                    Provider.of<UserDAO>(
                                                        context,
                                                        listen: false);
                                                await userService
                                                    .removeUserFromCompany(
                                                        user.id, companyId);
                                                Navigator.of(context)
                                                    .pushReplacementNamedNoTransition(
                                                        RoutePaths.home);
                                              });
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : null,
                );
              },
            );
          }
        },
      ),
    );
  }
}
