import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/features/warehouse/ui/pages/warehouse_page.dart';
import 'package:inventory_system/features/warehouse/ui/widgets/edit_warehouse_screen.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class WarehouseTile extends StatelessWidget {
  final Warehouse warehouse;

  const WarehouseTile({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    final warehouseDAO = Provider.of<WarehouseDAO>(context, listen: false);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('Name: ${warehouse.name}'),
        subtitle: Text('Address: ${warehouse.address}'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Navigate to edit screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditWarehouseScreen(warehouse: warehouse),
              ),
            );
          },
        ),
        onLongPress: () {
          // Show delete confirmation dialog
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Delete Warehouse'),
                content:
                    Text('Are you sure you want to delete ${warehouse.name}?'),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      warehouseDAO.deleteWarehouse(warehouse.id);
                      Navigator.of(context).pushReplacementNamedNoTransition(
                          RoutePaths.warehouses);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
