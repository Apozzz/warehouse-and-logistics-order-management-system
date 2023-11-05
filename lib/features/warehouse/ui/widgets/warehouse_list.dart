import 'package:flutter/material.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/ui/widgets/warehouse_tile.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class WarehouseList extends StatefulWidget {
  const WarehouseList({Key? key}) : super(key: key);

  @override
  State<WarehouseList> createState() => _WarehouseListState();
}

class _WarehouseListState extends State<WarehouseList> {
  late Future<List<Warehouse>> warehousesFuture;

  @override
  void initState() {
    super.initState();
    fetchWarehousesWithCompanyId();
  }

  void fetchWarehousesWithCompanyId() {
    withCompanyId(context, (companyId) async {
      final warehouseDAO = Provider.of<WarehouseDAO>(context, listen: false);
      warehousesFuture = warehouseDAO.fetchWarehouses(companyId);
      // The following line is important as it triggers a rebuild after the future is set
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Warehouse>>(
      future: warehousesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Warehouse> warehouses = snapshot.data!;
          return ListView.separated(
            itemCount: warehouses.length,
            itemBuilder: (context, index) {
              final warehouse = warehouses[index];
              return WarehouseTile(warehouse: warehouse);
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        } else {
          return const Center(child: Text('No warehouses found.'));
        }
      },
    );
  }
}
