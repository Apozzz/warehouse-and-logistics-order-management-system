import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/features/authentication/ui/pages/auth_selection_page.dart';
import 'package:inventory_system/features/authentication/ui/pages/logout_page.dart';
import 'package:inventory_system/features/category/ui/pages/category_page.dart';
import 'package:inventory_system/features/company/ui/pages/company_details_page.dart';
import 'package:inventory_system/features/company/ui/pages/company_page.dart';
import 'package:inventory_system/features/company/ui/pages/create_company_page.dart';
import 'package:inventory_system/features/company/ui/pages/join_company_page.dart';
import 'package:inventory_system/features/dashboard/ui/pages/dashboard_page.dart';
import 'package:inventory_system/features/delivery/ui/pages/delivery_page.dart';
import 'package:inventory_system/features/notification/ui/pages/user_notifications_page.dart';
import 'package:inventory_system/features/order/ui/pages/order_page.dart';
import 'package:inventory_system/features/packages/ui/pages/package_progress_overview_page.dart';
import 'package:inventory_system/features/product/ui/pages/product_page.dart';
import 'package:inventory_system/features/role/ui/pages/role_page.dart';
import 'package:inventory_system/features/user/models/user_model.dart';
import 'package:inventory_system/features/user/ui/pages/user_details_form_page.dart';
import 'package:inventory_system/features/vehicle/ui/pages/vehicle_page.dart';
import 'package:inventory_system/features/warehouse/ui/pages/warehouse_page.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
import 'package:inventory_system/shared/ui/pages/no_access_page.dart';
import 'package:provider/provider.dart';

typedef RouteBuilder = Widget Function(BuildContext context);
typedef RouteBuilderWithArgs = Widget Function(
    BuildContext context, Object? args);

class RouteConfig {
  final String path;
  final RouteBuilder? builder;
  final RouteBuilderWithArgs? builderWithArgs;
  final bool isProtected;
  final AppPage? appPage; // Add this line

  RouteConfig({
    required this.path,
    this.builder,
    this.builderWithArgs,
    this.isProtected = false,
    this.appPage, // Add this line
  });
}

final List<RouteConfig> routeConfigs = [
  RouteConfig(
    path: RoutePaths.home,
    builder: (context) {
      final company =
          Provider.of<CompanyProvider>(context, listen: false).company;
      return CompanyDetailsPage(company: company!);
    },
    isProtected: true,
    appPage: AppPage.CompanyDetails,
  ),
  RouteConfig(
    path: RoutePaths.selectCompany,
    builder: (_) => const CompanySelectionPage(),
  ),
  RouteConfig(
    path: RoutePaths.createCompany,
    builder: (_) => const CompanyCreatePage(),
  ),
  RouteConfig(
    path: RoutePaths.joinCompany,
    builder: (_) => CompanyJoinPage(),
  ),
  RouteConfig(
    path: RoutePaths.auth,
    builder: (_) => const AuthSelectionPage(),
  ),
  RouteConfig(
    path: RoutePaths.notifications,
    builder: (_) => const UserNotificationsPage(),
  ),
  RouteConfig(
    path: RoutePaths.logout,
    builder: (_) => const LogoutPage(),
  ),
  RouteConfig(
    path: RoutePaths.noAccess,
    builder: (_) => const NoAccessPage(),
  ),
  RouteConfig(
    path: RoutePaths.userDetails,
    builderWithArgs: (_, args) => UserDetailsFormPage(user: args as User),
  ),
  RouteConfig(
    path: RoutePaths.dashboard,
    builder: (_) => const DashboardPage(),
    isProtected: true,
    appPage: AppPage.Dashboard,
  ),
  RouteConfig(
    path: RoutePaths.deliveries,
    builder: (_) => const DeliveryPage(),
    isProtected: true,
    appPage: AppPage.Delivery,
  ),
  RouteConfig(
    path: RoutePaths.orders,
    builder: (_) => const OrderPage(),
    isProtected: true,
    appPage: AppPage.Orders,
  ),
  RouteConfig(
    path: RoutePaths.products,
    builder: (_) => const ProductPage(),
    isProtected: true,
    appPage: AppPage.Products,
  ),
  RouteConfig(
    path: RoutePaths.roles,
    builder: (_) => const RolePage(),
    isProtected: true,
    appPage: AppPage.Roles,
  ),
  RouteConfig(
    path: RoutePaths.vehicles,
    builder: (_) => const VehiclePage(),
    isProtected: true,
    appPage: AppPage.Vehicles,
  ),
  RouteConfig(
    path: RoutePaths.warehouses,
    builder: (_) => const WarehousePage(),
    isProtected: true,
    appPage: AppPage.Warehouses,
  ),
  RouteConfig(
    path: RoutePaths.categories,
    builder: (_) => const CategoryPage(),
    isProtected: true,
    appPage: AppPage.Categories,
  ),
  RouteConfig(
    path: RoutePaths.packaging,
    builderWithArgs: (_, args) =>
        PackageProgressOverviewPage(canViewAll: args as bool),
    isProtected: true,
    appPage: AppPage.Packaging,
  ),
];
