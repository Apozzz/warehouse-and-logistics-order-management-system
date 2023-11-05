import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:inventory_system/features/company/DAOs/company_dao.dart';
import 'package:inventory_system/features/company/ui/pages/company_details_page.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
import 'package:inventory_system/shared/ui/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final FloatingActionButton? floatingActionButton;
  final bool? resizeToAvoidBottomInset;

  const BaseScaffold({
    Key? key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final companyDAO = Provider.of<CompanyDAO>(context, listen: false);
    final navigator = Navigator.of(context);
    final companyId = Provider.of<CompanyProvider>(context).companyId;

    return Scaffold(
      appBar: appBar,
      drawer: const AppDrawer(),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: companyId != null
          ? GNav(
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  onPressed: () {
                    withCompanyId(context, (companyId) async {
                      final company = await companyDAO.getCompany(companyId);
                      // Use the navigator state here
                      navigator.pushReplacementNoTransition(
                          CompanyDetailsPage(company: company));
                      return null; // this line is just to satisfy the return type of withCompanyId
                    });
                  },
                ),
                // ... other GButton items for other tabs
              ],
              onTabChange: (index) {
                // handle tab changes if needed
              },
            )
          : null,
      resizeToAvoidBottomInset:
          resizeToAvoidBottomInset, // Hide GNav if companyId is null
    );
  }
}
