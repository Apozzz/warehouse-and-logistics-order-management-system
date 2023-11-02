import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
import 'package:inventory_system/features/role/services/role_service.dart';
import 'package:inventory_system/features/user/services/user_service.dart';
import 'package:inventory_system/features/warehouse/repositories/warehouse_repository.dart';
import 'package:inventory_system/features/warehouse/services/warehouse_service.dart';
import 'package:inventory_system/firebase_options.dart';
import 'package:inventory_system/shared/ui/widgets/app_drawer.dart';
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
      Provider<CompanyDAO>(
        create: (_) => CompanyDAO(),
      ),
      Provider<RoleService>(
        create: (_) => RoleService(),
      ),
      Provider<CompanyService>(
        create: (context) {
          final roleService = Provider.of<RoleService>(context, listen: false);
          final companyDAO = Provider.of<CompanyDAO>(context, listen: false);
          return CompanyService(roleService, companyDAO);
        },
      ),
      Provider<UserService>(
        create: (context) {
          final companyDAO = Provider.of<CompanyDAO>(context, listen: false);
          return UserService(companyDAO);
        },
      ),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final email =
        Provider.of<EmailPasswordAuthViewModel>(context, listen: false);
    email.signIn();
    return ChangeNotifierProvider(
      create: (context) =>
          WarehouseService(WarehouseRepository(FirebaseFirestore.instance)),
      child: MaterialApp(
        title: 'Inventory System',
        theme: buildTheme(),
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
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Inventory System'),
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ),
                  drawer: const AppDrawer(),
                  body: const CompanySelectionPage(),
                );
              }
            } else {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
          },
        ),
      ),
    );
  }
}
