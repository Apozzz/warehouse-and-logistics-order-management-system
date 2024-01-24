import 'package:flutter/material.dart';
import 'package:inventory_system/features/warehouse/ui/pages/warehouse_page.dart'; // Import your WarehousePage
import 'package:inventory_system/features/sector/ui/pages/sector_page.dart'; // Import your SectorPage
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';

class WarehouseAndSectorPage extends StatefulWidget {
  final int initialTabIndex;

  const WarehouseAndSectorPage({super.key, this.initialTabIndex = 0});

  @override
  _WarehouseAndSectorPageState createState() => _WarehouseAndSectorPageState();
}

class _WarehouseAndSectorPageState extends State<WarehouseAndSectorPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
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
        title: const Text('Warehouse & Sector Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Warehouses'),
            Tab(text: 'Sectors'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // First tab - Warehouse Page
          WarehousePage(),
          // Second tab - Sector Page
          SectorPage(), // Assuming you have a SectorPage
        ],
      ),
    );
  }
}
