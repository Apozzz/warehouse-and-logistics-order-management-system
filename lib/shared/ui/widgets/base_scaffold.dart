import 'package:flutter/material.dart';
import 'package:inventory_system/shared/ui/widgets/app_drawer.dart';
import 'package:inventory_system/shared/ui/widgets/custom_navigation_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: const AppDrawer(),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: const CustomNavigationBar(),
      resizeToAvoidBottomInset:
          resizeToAvoidBottomInset, // Hide GNav if companyId is null
    );
  }
}
