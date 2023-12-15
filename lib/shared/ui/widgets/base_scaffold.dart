import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/features/user/models/user_model.dart';
import 'package:inventory_system/features/user/services/user_service.dart';
import 'package:inventory_system/features/user/ui/widgets/user_avatar.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/ui/widgets/app_drawer.dart';
import 'package:inventory_system/shared/ui/widgets/custom_navigation_bar.dart';
import 'package:provider/provider.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final Widget? floatingActionButton;
  final bool? resizeToAvoidBottomInset;

  const BaseScaffold({
    Key? key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);

  AppBar _buildAppBar(BuildContext context, AppBar? customAppBar) {
    final firebaseUser = Provider.of<AuthViewModel>(context).currentUser;
    final userService = Provider.of<UserService>(context);

    if (firebaseUser == null) {
      return AppBar(title: customAppBar?.title ?? const Text(''));
    }

    return AppBar(
      title: customAppBar?.title ?? const Text(''),
      actions: <Widget>[
        FutureBuilder<User?>(
          future: userService.getUserModelByFirebaseUserId(firebaseUser.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Or some other loading indicator
            }

            if (snapshot.hasData && snapshot.data != null) {
              final user = snapshot.data!;
              return UserAvatar(userName: user.name, user: user);
            }

            return const SizedBox(); // Empty widget if user data is not available
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, appBar),
      drawer: const AppDrawer(),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: const CustomNavigationBar(),
      resizeToAvoidBottomInset:
          resizeToAvoidBottomInset, // Hide GNav if companyId is null
    );
  }
}
