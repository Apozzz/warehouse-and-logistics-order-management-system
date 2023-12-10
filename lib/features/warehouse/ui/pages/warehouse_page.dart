import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/warehouse/ui/widgets/add_warehouse_form.dart';
import 'package:inventory_system/features/warehouse/ui/widgets/warehouse_list.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  _WarehousePageState createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  void refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Warehouses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshList,
          ),
        ],
      ),
      body: const WarehouseList(),
      floatingActionButton: PermissionControlledActionButton(
        appPage: AppPage.Warehouses, // Specify the AppPage for the delivery
        permissionType: PermissionType.Manage,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => AddWarehouseForm(
                onWarehouseAdded: refreshList,
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
