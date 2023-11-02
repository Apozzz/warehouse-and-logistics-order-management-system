import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/features/company/ui/pages/company_page.dart';
import 'package:inventory_system/features/warehouse/ui/pages/warehouse_page.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Company'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CompanySelectionPage(),
              ));
            },
          ),
          ListTile(
            title: const Text('Warehouse'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const WarehousePage(),
              ));
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              final authViewModel =
                  Provider.of<AuthViewModel>(context, listen: false);
              authViewModel.signOut();
            },
          ),
        ],
      ),
    );
  }
}
