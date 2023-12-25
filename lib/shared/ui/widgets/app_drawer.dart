import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/shared/managers/navigation_manager.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NavigationManager navigationManager =
        Provider.of<NavigationManager>(context, listen: false);
    final companyId =
        Provider.of<CompanyProvider>(context, listen: false).companyId;

    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Drawer Header',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _createDrawerItemFuture(context, 'Companies',
              RoutePaths.selectCompany, null, navigationManager),
          if (companyId != null) ...[
            _createDrawerItemFuture(context, 'Categories',
                RoutePaths.categories, AppPage.Categories, navigationManager),
            _createDrawerItemFuture(context, 'Products', RoutePaths.products,
                AppPage.Products, navigationManager),
            _createDrawerItemFuture(context, 'Warehouses',
                RoutePaths.warehouses, AppPage.Warehouses, navigationManager),
            _createDrawerItemFuture(context, 'Orders', RoutePaths.orders,
                AppPage.Orders, navigationManager),
            _createDrawerItemFuture(context, 'Deliveries',
                RoutePaths.deliveries, AppPage.Delivery, navigationManager),
            _createDrawerItemFuture(context, 'Vehicles', RoutePaths.vehicles,
                AppPage.Vehicles, navigationManager),
            _createDrawerItemFuture(context, 'Roles', RoutePaths.roles,
                AppPage.Roles, navigationManager),
          ],
          _createDrawerItemFuture(
              context, 'Logout', RoutePaths.auth, null, navigationManager),
        ],
      ),
    );
  }

  Widget _createDrawerItemFuture(BuildContext context, String title,
      String route, AppPage? appPage, NavigationManager navigationManager) {
    return FutureBuilder<Widget>(
      future: navigationManager.createNavItem(
          context, title, Icons.circle, route, appPage),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        // Return a loading indicator, an empty container, or the list tile
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Or a placeholder widget
        } else if (snapshot.hasError) {
          return const SizedBox.shrink(); // Handle error state appropriately
        } else {
          return snapshot.data ??
              const SizedBox
                  .shrink(); // Return the item or hide if not permitted
        }
      },
    );
  }
}
