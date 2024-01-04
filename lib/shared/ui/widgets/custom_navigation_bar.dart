import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/shared/managers/navigation_manager.dart';
import 'package:inventory_system/shared/services/permission_service.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationManager navManager =
        Provider.of<NavigationManager>(context);
    final PermissionService permissionService =
        Provider.of<PermissionService>(context);

    return FutureBuilder<List<GButton>>(
      future: _buildNavButtons(context, navManager, permissionService),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or some placeholder
        }

        return GNav(
          selectedIndex: navManager.currentIndex,
          onTabChange: navManager.setCurrentIndex,
          tabs: snapshot.data ?? [],
        );
      },
    );
  }

  Future<List<GButton>> _buildNavButtons(BuildContext context,
      NavigationManager navManager, PermissionService permissionService) async {
    List<GButton> buttons = [];
    final permissions =
        await permissionService.fetchViewPermissions(AppPage.Packaging);
    // Add navbar items
    buttons.add(await navManager.createNavbarItem(
        context, 'Home', Icons.home, RoutePaths.home,
        appPage: AppPage.CompanyDetails, index: 0));
    buttons.add(await navManager.createNavbarItem(
        context, 'Dashboard', Icons.dashboard, RoutePaths.dashboard,
        appPage: AppPage.Dashboard, index: 1));
    buttons.add(await navManager.createNavbarItem(
        context, 'Packaging', FontAwesomeIcons.boxOpen, RoutePaths.packaging,
        appPage: AppPage.Packaging, index: 2, arguments: permissions.viewAll));
    buttons.add(await navManager.createNavbarItem(
        context, 'Notifications', Icons.notifications, RoutePaths.notifications,
        index: 3));
    // ... other navbar items ...
    return buttons;
  }
}
