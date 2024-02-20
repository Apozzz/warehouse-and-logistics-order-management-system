import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_system/constants/route_paths.dart';
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
import 'package:inventory_system/features/category/DAOs/category_dao.dart';
import 'package:inventory_system/features/category/services/category_service.dart';
import 'package:inventory_system/features/company/DAOs/company_dao.dart';
import 'package:inventory_system/features/company/services/company_service.dart';
import 'package:inventory_system/features/company/ui/pages/company_page.dart';
import 'package:inventory_system/features/dashboard/services/dashboard_data_service.dart';
import 'package:inventory_system/features/delivery/DAOs/delivery_dao.dart';
import 'package:inventory_system/features/delivery/DAOs/ongoing_delivery_session_dao.dart';
import 'package:inventory_system/features/delivery/services/ongoing_delivery_session_servide.dart';
import 'package:inventory_system/features/google_maps/services/google_maps_service.dart';
import 'package:inventory_system/features/notification/DAOs/notification_dao.dart';
import 'package:inventory_system/features/notification/services/notification_service.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/order/services/order_service.dart';
import 'package:inventory_system/features/packages/DAOs/package_progress_dao.dart';
import 'package:inventory_system/features/packages/services/packaging_service.dart';
import 'package:inventory_system/features/product/DAOs/product_dao.dart';
import 'package:inventory_system/features/role/DAOs/role_dao.dart';
import 'package:inventory_system/features/sector/DAOs/sector_dao.dart';
import 'package:inventory_system/features/user/DAOs/user_dao.dart';
import 'package:inventory_system/features/user/services/user_service.dart';
import 'package:inventory_system/features/vehicle/DAOs/vehicle_dao.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/firebase_options.dart';
import 'package:inventory_system/shared/guards/route_config.dart';
import 'package:inventory_system/shared/guards/route_guard.dart';
import 'package:inventory_system/shared/managers/navigation_manager.dart';
import 'package:inventory_system/shared/observers/connectivity_aware_navigator_observer.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
import 'package:inventory_system/shared/providers/delivery_tracking_provider.dart';
import 'package:inventory_system/shared/providers/navigation_provider.dart';
import 'package:inventory_system/shared/services/camera_service.dart';
import 'package:inventory_system/shared/services/connectivity_service.dart';
import 'package:inventory_system/shared/services/images_service.dart';
import 'package:inventory_system/shared/services/location_tracking_service.dart';
import 'package:inventory_system/shared/services/permission_service.dart';
import 'package:inventory_system/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e is FirebaseException && e.code == 'duplicate-app') {
      // Ignore 'duplicate-app' errors during initialization
      print('Firebase App already initialized');
    } else {
      rethrow;
    }
  }

  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

    return MultiProvider(
      providers: [
        Provider<UserDAO>(create: (_) => UserDAO()),
        Provider<RoleDAO>(create: (_) => RoleDAO()),
        Provider<CompanyDAO>(create: (_) => CompanyDAO()),
        Provider<PackageProgressDAO>(create: (_) => PackageProgressDAO()),
        Provider<DeliveryDAO>(create: (_) => DeliveryDAO()),
        Provider<VehicleDAO>(create: (_) => VehicleDAO()),
        Provider<NotificationDAO>(create: (_) => NotificationDAO()),
        Provider<CategoryDAO>(create: (_) => CategoryDAO()),
        Provider<WarehouseDAO>(create: (_) => WarehouseDAO()),
        Provider<ProductDAO>(create: (_) => ProductDAO()),
        Provider<SectorDAO>(create: (_) => SectorDAO()),
        Provider<OngoingDeliverySessionDAO>(
            create: (_) => OngoingDeliverySessionDAO()),
        Provider<OrderDAO>(
          create: (context) {
            final productDAO = Provider.of<ProductDAO>(context, listen: false);
            return OrderDAO(productDAO);
          },
        ),
        Provider<ImagePicker>(create: (_) => ImagePicker()),
        Provider<DashboardDataService>(create: (_) => DashboardDataService()),
        Provider<ImageService>(create: (_) => ImageService()),
        Provider<CameraService>(create: (_) => CameraService()),
        Provider<GoogleMapsService>(create: (_) => GoogleMapsService(apiKey)),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(
          create: (context) => CompanyProvider(
            Provider.of<CompanyDAO>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        Provider<PackagingService>(
          create: (context) => PackagingService(
            Provider.of<PackageProgressDAO>(context, listen: false),
            Provider.of<DeliveryDAO>(context, listen: false),
          ),
        ),
        Provider<PermissionService>(
          create: (context) => PermissionService(
            Provider.of<RoleDAO>(context, listen: false),
            Provider.of<CompanyDAO>(context, listen: false),
            Provider.of<AuthViewModel>(context, listen: false),
            Provider.of<CompanyProvider>(context, listen: false),
          ),
        ),
        Provider<UserService>(
          create: (context) => UserService(
            Provider.of<UserDAO>(context, listen: false),
            Provider.of<PermissionService>(context, listen: false),
          ),
        ),
        Provider<OngoingDeliverySessionService>(
          create: (context) => OngoingDeliverySessionService(
            Provider.of<OngoingDeliverySessionDAO>(context, listen: false),
          ),
        ),
        Provider<LocationTrackingService>(
          create: (_) => LocationTrackingService(),
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
        ChangeNotifierProvider(
          create: (context) => DeliveryTrackingProvider(
            Provider.of<LocationTrackingService>(context, listen: false),
            Provider.of<GoogleMapsService>(context, listen: false),
            Provider.of<ImageService>(context, listen: false),
            Provider.of<OngoingDeliverySessionService>(context, listen: false),
          ),
        ),
        Provider<CompanyService>(
          create: (context) {
            final companyDAO = Provider.of<CompanyDAO>(context, listen: false);
            final roleDAO = Provider.of<RoleDAO>(context, listen: false);
            final userDAO = Provider.of<UserDAO>(context, listen: false);
            return CompanyService(companyDAO, roleDAO, userDAO);
          },
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
        Provider<NavigationManager>(
          create: (context) => NavigationManager(
            Provider.of<PermissionService>(context, listen: false),
          ),
        ),
        Provider<CategoryService>(
          create: (context) => CategoryService(
            Provider.of<CategoryDAO>(context, listen: false),
            Provider.of<ProductDAO>(context, listen: false),
            Provider.of<OrderDAO>(context, listen: false),
            Provider.of<VehicleDAO>(context, listen: false),
          ),
        ),
        Provider<OrderService>(
          create: (context) => OrderService(
            Provider.of<ProductDAO>(context, listen: false),
          ),
        ),
      ],
      child: const MaterialAppWithConnectivity(),
    );
  }
}

class MaterialAppWithConnectivity extends StatelessWidget {
  const MaterialAppWithConnectivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Now we are sure to get a context that is below MultiProvider
    final connectivityService = Provider.of<ConnectivityService>(context);
    final navigatorObserver = ConnectivityAwareNavigatorObserver(
        connectivityService: connectivityService);

    return MaterialApp(
      title: 'Inventory System',
      theme: buildTheme(),
      navigatorObservers: [navigatorObserver],
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
          protected: routeConfig.isProtected,
          routeConfig: routeConfig,
          permissionService:
              Provider.of<PermissionService>(context, listen: false),
        );
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.active) {
            User? user = authSnapshot.data;

            if (user == null) {
              return const AuthSelectionPage();
            } else {
              return const CompanySelectionPage();
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
