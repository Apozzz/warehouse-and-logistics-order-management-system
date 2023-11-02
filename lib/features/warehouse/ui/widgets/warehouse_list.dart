import 'package:flutter/material.dart';
import 'package:inventory_system/features/warehouse/models/warehouse.dart';
import 'package:inventory_system/features/warehouse/services/warehouse_service.dart';
import 'package:inventory_system/features/warehouse/ui/widgets/warehouse_tile.dart';
import 'package:provider/provider.dart';

class WarehouseList extends StatelessWidget {
  const WarehouseList({super.key});

  @override
  Widget build(BuildContext context) {
    final warehouseService = Provider.of<WarehouseService>(context);

    return FutureBuilder(
      future: warehouseService.fetchWarehouses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ValueListenableBuilder<List<Warehouse>>(
            valueListenable: warehouseService.warehouses,
            builder: (context, warehouses, child) {
              return ListView.separated(
                itemCount: warehouses.length,
                itemBuilder: (context, index) {
                  final warehouse = warehouses[index];
                  return WarehouseTile(warehouse: warehouse);
                },
                separatorBuilder: (context, index) => const Divider(),
              );
            },
          );
        }
      },
    );
  }
}
