import 'package:flutter/material.dart';
import 'package:inventory_system/features/packages/ui/widgets/packaging_transportation_list.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
// Add other necessary imports

class PackageProgressOverviewPage extends StatefulWidget {
  final bool canViewAll;

  const PackageProgressOverviewPage({Key? key, required this.canViewAll})
      : super(key: key);

  @override
  _PackageProgressOverviewPageState createState() =>
      _PackageProgressOverviewPageState();
}

class _PackageProgressOverviewPageState
    extends State<PackageProgressOverviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {}); // Triggers a rebuild when the tab changes
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Package Progress Overview'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Packaging'),
            Tab(text: 'Transportation'),
          ],
        ),
      ),
      body: PackagingTransportationList(
        canViewAll: widget.canViewAll,
        tabController: _tabController,
      ),
    );
  }
}
