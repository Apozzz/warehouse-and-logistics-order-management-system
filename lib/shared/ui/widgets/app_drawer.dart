import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/ui/pages/auth_selection_page.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/features/company/ui/pages/company_page.dart';
import 'package:inventory_system/features/delivery/ui/pages/delivery_page.dart';
import 'package:inventory_system/features/order/ui/pages/order_page.dart';
import 'package:inventory_system/features/product/ui/pages/product_page.dart';
import 'package:inventory_system/features/role/ui/pages/role_page.dart';
import 'package:inventory_system/features/vehicle/ui/pages/vehicle_page.dart';
import 'package:inventory_system/features/warehouse/ui/pages/warehouse_page.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
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
          Consumer<CompanyProvider>(
            builder: (context, companyProvider, child) {
              final companyId = companyProvider.companyId;
              if (companyId != null) {
                return ListTile(
                  title: const Text('Companies'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer
                    Navigator.of(context).pushReplacementNoTransition(
                        const CompanySelectionPage());
                  },
                );
              }
              return const SizedBox
                  .shrink(); // Return an empty widget if companyId is null
            },
          ),
          Consumer<CompanyProvider>(
            builder: (context, companyProvider, child) {
              final companyId = companyProvider.companyId;
              if (companyId != null) {
                return ListTile(
                  title: const Text('Products'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer
                    Navigator.of(context)
                        .pushReplacementNoTransition(const ProductPage());
                  },
                );
              }
              return const SizedBox
                  .shrink(); // Return an empty widget if companyId is null
            },
          ),
          Consumer<CompanyProvider>(
            builder: (context, companyProvider, child) {
              final companyId = companyProvider.companyId;
              if (companyId != null) {
                return ListTile(
                  title: const Text('Warehouses'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer
                    Navigator.of(context)
                        .pushReplacementNoTransition(const WarehousePage());
                  },
                );
              }
              return const SizedBox
                  .shrink(); // Return an empty widget if companyId is null
            },
          ),
          Consumer<CompanyProvider>(
            builder: (context, companyProvider, child) {
              final companyId = companyProvider.companyId;
              if (companyId != null) {
                return ListTile(
                  title: const Text('Orders'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer
                    Navigator.of(context)
                        .pushReplacementNoTransition(const OrderPage());
                  },
                );
              }
              return const SizedBox
                  .shrink(); // Return an empty widget if companyId is null
            },
          ),
          Consumer<CompanyProvider>(
            builder: (context, companyProvider, child) {
              final companyId = companyProvider.companyId;
              if (companyId != null) {
                return ListTile(
                  title: const Text('Deliveries'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer
                    Navigator.of(context)
                        .pushReplacementNoTransition(const DeliveryPage());
                  },
                );
              }
              return const SizedBox
                  .shrink(); // Return an empty widget if companyId is null
            },
          ),
          Consumer<CompanyProvider>(
            builder: (context, companyProvider, child) {
              final companyId = companyProvider.companyId;
              if (companyId != null) {
                return ListTile(
                  title: const Text('Vehicles'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer
                    Navigator.of(context)
                        .pushReplacementNoTransition(const VehiclePage());
                  },
                );
              }
              return const SizedBox
                  .shrink(); // Return an empty widget if companyId is null
            },
          ),
          Consumer<CompanyProvider>(
            builder: (context, companyProvider, child) {
              final companyId = companyProvider.companyId;
              if (companyId != null) {
                return ListTile(
                  title: const Text('Roles'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer
                    Navigator.of(context)
                        .pushReplacementNoTransition(const RolePage());
                  },
                );
              }
              return const SizedBox
                  .shrink(); // Return an empty widget if companyId is null
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              final authViewModel =
                  Provider.of<AuthViewModel>(context, listen: false);
              authViewModel.signOut();
              Navigator.of(context)
                  .pushReplacementNoTransition(const AuthSelectionPage());
            },
          ),
        ],
      ),
    );
  }
}
