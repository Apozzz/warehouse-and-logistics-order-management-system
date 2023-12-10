import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/features/authentication/services/email_password_authentication.dart';
import 'package:inventory_system/features/authentication/services/facebook_authentaction.dart';
import 'package:inventory_system/features/authentication/services/google_authentication.dart';
import 'package:inventory_system/features/authentication/services/mobile_number_authentication.dart';
import 'package:inventory_system/features/authentication/ui/pages/auth_selection_page.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/features/authentication/viewmodels/email_password_authentication_view_model.dart';
import 'package:inventory_system/features/authentication/viewmodels/facebook_authentication_view_model.dart';
import 'package:inventory_system/features/authentication/viewmodels/google_authentication_view_model.dart';
import 'package:inventory_system/features/authentication/viewmodels/mobile_number_authentication_view_model.dart';
import 'package:inventory_system/features/company/DAOs/company_dao.dart';
import 'package:inventory_system/features/company/services/company_service.dart';
import 'package:inventory_system/features/company/ui/pages/company_page.dart';
import 'package:inventory_system/features/dashboard/services/dashboard_data_service.dart';
import 'package:inventory_system/features/delivery/DAOs/delivery_dao.dart';
import 'package:inventory_system/features/notification/DAOs/notification_dao.dart';
import 'package:inventory_system/features/notification/services/notification_service.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/product/DAOs/product_dao.dart';
import 'package:inventory_system/features/role/DAOs/role_dao.dart';
import 'package:inventory_system/features/user/DAOs/user_dao.dart';
import 'package:inventory_system/features/user/services/user_service.dart';
import 'package:inventory_system/features/vehicle/DAOs/vehicle_dao.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/firebase_options.dart';
import 'package:inventory_system/shared/guards/route_config.dart';
import 'package:inventory_system/shared/guards/route_guard.dart';
import 'package:inventory_system/shared/managers/navigation_manager.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
import 'package:inventory_system/shared/providers/navigation_provider.dart';
import 'package:inventory_system/shared/services/permission_service.dart';
import 'package:inventory_system/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => AuthViewModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => GoogleAuthViewModel(
          GoogleAuthentication(),
          Provider.of<AuthViewModel>(context, listen: false),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => FacebookAuthViewModel(
          FacebookAuthentication(),
          Provider.of<AuthViewModel>(context, listen: false),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => EmailPasswordAuthViewModel(
          EmailPasswordAuthentication(),
          Provider.of<AuthViewModel>(context, listen: false),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => MobileNumberAuthViewModel(
          MobileNumberAuthentication(),
          Provider.of<AuthViewModel>(context, listen: false),
        ),
      ),
      ChangeNotifierProvider(create: (context) => NavigationProvider()),
      Provider<CompanyDAO>(
        create: (context) => CompanyDAO(),
      ),
      Provider<UserDAO>(
        create: (context) => UserDAO(),
      ),
      Provider<RoleDAO>(
        create: (context) => RoleDAO(),
      ),
      Provider<WarehouseDAO>(
        create: (context) => WarehouseDAO(),
      ),
      Provider<ProductDAO>(
        create: (context) => ProductDAO(),
      ),
      Provider<OrderDAO>(
        create: (context) => OrderDAO(),
      ),
      Provider<VehicleDAO>(
        create: (context) => VehicleDAO(),
      ),
      Provider<DeliveryDAO>(
        create: (context) => DeliveryDAO(),
      ),
      Provider<NotificationDAO>(
        create: (_) => NotificationDAO(),
      ),
      Provider<UserService>(
        create: (context) {
          final companyDAO = Provider.of<CompanyDAO>(context, listen: false);
          final userDAO = Provider.of<UserDAO>(context, listen: false);
          return UserService(companyDAO, userDAO);
        },
      ),
      Provider<CompanyService>(
        create: (context) {
          final companyDAO = Provider.of<CompanyDAO>(context, listen: false);
          final roleDAO = Provider.of<RoleDAO>(context, listen: false);
          final userDAO = Provider.of<UserDAO>(context, listen: false);
          return CompanyService(companyDAO, roleDAO, userDAO);
        },
      ),
      ChangeNotifierProvider(
        create: (context) => CompanyProvider(
          Provider.of<CompanyDAO>(context, listen: false),
        ),
      ),
      Provider<DashboardDataService>(
        create: (context) => DashboardDataService(),
      ),
      Provider<NotificationService>(
        create: (context) {
          final notificationDAO =
              Provider.of<NotificationDAO>(context, listen: false);
          final notificationService = NotificationService(
              context: context, notificationDAO: notificationDAO);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notificationService.initializeNotifications();
          });

          return notificationService;
        },
      ),
      Provider<PermissionService>(
        create: (context) => PermissionService(
          Provider.of<RoleDAO>(context, listen: false),
          Provider.of<CompanyDAO>(context, listen: false),
          Provider.of<AuthViewModel>(context, listen: false),
          Provider.of<CompanyProvider>(context, listen: false),
        ),
      ),
      Provider<NavigationManager>(
        create: (context) => NavigationManager(
          Provider.of<PermissionService>(context, listen: false),
        ),
      ),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final email =
    //     Provider.of<EmailPasswordAuthViewModel>(context, listen: false);
    // email.signIn();
    return MaterialApp(
      title: 'Inventory System',
      theme: buildTheme(),
      onGenerateRoute: (RouteSettings settings) {
        final routeConfig = routeConfigs.firstWhere(
          (config) => config.path == settings.name,
          orElse: () => RouteConfig(
            path: RoutePaths.selectCompany,
            builder: (_) => const CompanySelectionPage(),
          ),
        );

        return RouteGuard.generateRoute(
          settings,
          routeConfig.builder,
          protected: routeConfig.isProtected,
          appPage: routeConfig.appPage,
          permissionService:
              Provider.of<PermissionService>(context, listen: false),
        );
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;

            if (user != null) {
              // User is signed in. Create/update user document in Firestore.
              final userService =
                  Provider.of<UserService>(context, listen: false);
              userService.createUser(user);
            }

            if (user == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Inventory System')),
                body: const AuthSelectionPage(),
              );
            } else {
              return const Scaffold(
                body: CompanySelectionPage(),
              );
            }
          } else {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }
}
