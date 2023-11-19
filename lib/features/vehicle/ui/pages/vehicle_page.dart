import 'package:flutter/material.dart';
import 'package:inventory_system/features/vehicle/ui/widgets/add_vehicle.dart';
import 'package:inventory_system/features/vehicle/ui/widgets/vehicle_list.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';

class VehiclePage extends StatelessWidget {
  const VehiclePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
      ),
      body: const VehicleList(), // Vehicle list widget
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddVehicleForm(context);
        },
        child: const Icon(Icons.add),
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
