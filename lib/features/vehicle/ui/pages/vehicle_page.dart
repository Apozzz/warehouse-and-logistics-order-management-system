import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/vehicle/ui/widgets/add_vehicle.dart';
import 'package:inventory_system/features/vehicle/ui/widgets/vehicle_list.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';

class VehiclePage extends StatelessWidget {
  const VehiclePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
      ),
      body: const VehicleList(), // Vehicle list widget
      floatingActionButton: PermissionControlledActionButton(
        appPage: AppPage.Vehicles, // Specify the AppPage for the delivery
        permissionType: PermissionType.Manage,
        child: FloatingActionButton(
          onPressed: () {
            _showAddVehicleForm(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddVehicleForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const Material(
            child: AddVehicleForm(), // Add vehicle form widget
          ),
        );
      },
    );
  }
}
