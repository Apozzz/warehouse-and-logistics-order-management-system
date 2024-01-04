import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/services/permission_service.dart';

class NavigationManager {
  final PermissionService _permissionService;
  int _currentIndex;
  bool _isDrawerItemActive;

  NavigationManager(this._permissionService)
      : _currentIndex = 0,
        _isDrawerItemActive = false;

  int get currentIndex => _currentIndex;
  bool get isDrawerItemActive => _isDrawerItemActive;

  void setCurrentIndex(int index, {bool isDrawerItem = false}) {
    _currentIndex = index;
    _isDrawerItemActive = isDrawerItem;
    // Notifying listeners is omitted here but you might need to call it if using a ChangeNotifier
  }

  void resetNavbarSelection() {
    if (_isDrawerItemActive) {
      _currentIndex = -1; // Invalid index to indicate no selection
      _isDrawerItemActive = false;
      // Notifying listeners is omitted here but you might need to call it if using a ChangeNotifier
    }
  }

  Future<Widget> createNavItem(BuildContext context, String title,
      IconData icon, String route, AppPage? appPage) async {
    bool hasPermission =
        true; // Default to true for pages that don't require specific permissions

    // Check permissions only for items associated with an AppPage
    if (appPage != null) {
      final permissions =
          await _permissionService.fetchViewPermissions(appPage);
      hasPermission = permissions.viewAll || permissions.viewSelf;
    }

    if (hasPermission) {
      return ListTile(
        title: Text(title),
        leading: Icon(icon),
        selected: _currentIndex == appPage?.index && !_isDrawerItemActive,
        onTap: () {
          setCurrentIndex(appPage?.index ?? -1,
              isDrawerItem: true); // Use ?? to handle null
          navigate(context, route);
        },
      );
    }
    return const SizedBox
        .shrink(); // Don't show the item if there's no permission
  }

  // New function to create a GButton for the navbar
  Future<GButton> createNavbarItem(
      BuildContext context, String title, IconData icon, String route,
      {AppPage? appPage, required int index, Object? arguments}) async {
    bool hasPermission =
        true; // Default to true for pages that don't require specific permissions
    // Check permissions only for items associated with an AppPage
    if (appPage != null) {
      final permissions =
          await _permissionService.fetchViewPermissions(appPage);
      hasPermission = permissions.viewAll || permissions.viewSelf;
    }

    if (hasPermission) {
      return GButton(
        icon: icon,
        text: title,
        onPressed: () {
          setCurrentIndex(index, isDrawerItem: false);
          navigate(context, route, arguments: arguments);
        },
      );
    } else {
      // Return a disabled GButton if no permission
      return GButton(
        icon: icon,
        text: title,
        onPressed: null, // This disables the button
        // Optionally adjust the appearance to reflect the disabled state
      );
    }
  }

  // Handle the navigation logic here to avoid repetition
  void navigate(BuildContext context, String route, {Object? arguments}) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop(); // Close the drawer if it's open
    }
    Navigator.of(context)
        .pushReplacementNamedNoTransition(route, arguments: arguments);
    if (_isDrawerItemActive) {
      resetNavbarSelection();
    }
  }
}
