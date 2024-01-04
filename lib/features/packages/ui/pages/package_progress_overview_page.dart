import 'package:flutter/material.dart';
import 'package:inventory_system/features/packages/ui/widgets/package_progress_list.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
// Add other necessary imports

class PackageProgressOverviewPage extends StatelessWidget {
  final bool canViewAll;

  const PackageProgressOverviewPage({Key? key, required this.canViewAll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: AppBar(
          title: const Text('Package Progress Overview'),
        ),
        body: PackageProgressList(canViewAll: canViewAll));
  }
}
