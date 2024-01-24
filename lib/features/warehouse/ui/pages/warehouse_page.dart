import 'package:flutter/material.dart';
import 'package:inventory_system/features/warehouse/ui/widgets/add_warehouse.dart';
import 'package:inventory_system/features/warehouse/ui/widgets/warehouse_list.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';

class WarehousePage extends StatelessWidget {
  const WarehousePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const WarehouseList(), // Displays the list of warehouses
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: PermissionControlledActionButton(
            appPage: AppPage.Warehouses,
            permissionType: PermissionType.Manage,
            child: FloatingActionButton(
              onPressed: () => _showAddWarehouseForm(context),
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddWarehouseForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const AddWarehouseWidget(), // Add warehouse form widget
        );
      },
    );
  }
}
