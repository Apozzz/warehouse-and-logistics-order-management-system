import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/features/warehouse/ui/widgets/edit_warehouse.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';
import 'package:provider/provider.dart';

class WarehouseActions extends StatelessWidget {
  final Warehouse warehouse;

  const WarehouseActions({Key? key, required this.warehouse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _editButton(context),
        _deleteButton(context),
      ],
    );
  }

  Widget _editButton(BuildContext context) {
    return PermissionControlledActionButton(
      appPage: AppPage.Warehouses,
      permissionType: PermissionType.Manage,
      child: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditWarehouseScreen(warehouse: warehouse),
            ),
          );
        },
      ),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return PermissionControlledActionButton(
      appPage: AppPage.Warehouses,
      permissionType: PermissionType.Manage,
      child: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _confirmDelete(context),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Warehouse'),
          content: Text(
              'Are you sure you want to delete the warehouse: ${warehouse.name}?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await _deleteWarehouse(context);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteWarehouse(BuildContext context) async {
    await withCompanyId<void>(context, (companyId) async {
      final warehouseDAO = Provider.of<WarehouseDAO>(context, listen: false);
      await warehouseDAO.deleteWarehouse(warehouse.id);
    });
  }
}
