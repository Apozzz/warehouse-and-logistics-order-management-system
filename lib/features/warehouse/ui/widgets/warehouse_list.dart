import 'package:flutter/material.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/features/warehouse/ui/widgets/warehouse_actions.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class WarehouseList extends StatefulWidget {
  const WarehouseList({Key? key}) : super(key: key);

  @override
  _WarehouseListState createState() => _WarehouseListState();
}

class _WarehouseListState extends State<WarehouseList> {
  late Future<List<Warehouse>> warehousesFuture;

  @override
  void initState() {
    super.initState();
    fetchWarehousesWithCompanyId();
  }

  Future<void> fetchWarehousesWithCompanyId() async {
    await withCompanyId(context, (companyId) async {
      final warehouseDAO = Provider.of<WarehouseDAO>(context, listen: false);
      warehousesFuture = warehouseDAO.fetchWarehouses(companyId);
      setState(() {});
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
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No warehouses found.'));
        }

        List<Warehouse> warehouses = snapshot.data!;
        return ListView.separated(
          itemCount: warehouses.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final warehouse = warehouses[index];
            return ListTile(
              title: Text('Warehouse: ${warehouse.name}'),
              subtitle: Text('Address: ${warehouse.address}'),
              trailing: WarehouseActions(
                  warehouse:
                      warehouse), // This widget will handle actions for each warehouse
            );
          },
        );
      },
    );
  }

  // Additional methods as needed...
}
