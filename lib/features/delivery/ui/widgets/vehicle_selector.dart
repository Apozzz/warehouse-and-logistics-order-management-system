import 'package:flutter/material.dart';
import 'package:inventory_system/features/vehicle/DAOs/vehicle_dao.dart';
import 'package:inventory_system/features/vehicle/models/vehicle_model.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class VehicleSelect extends StatefulWidget {
  final Vehicle? initialVehicle;
  final Function(Vehicle?) onSelected;

  const VehicleSelect({
    Key? key,
    this.initialVehicle,
    required this.onSelected,
  }) : super(key: key);

  @override
  _VehicleSelectState createState() => _VehicleSelectState();
}

class _VehicleSelectState extends State<VehicleSelect> {
  Vehicle? selectedVehicle;

  @override
  void initState() {
    super.initState();
    selectedVehicle = widget.initialVehicle;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Vehicle>?>(
      future: withCompanyId(
        context,
        (companyId) => Provider.of<VehicleDAO>(context, listen: false)
            .fetchVehicles(companyId),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No vehicles available.');
        } else {
          List<Vehicle> vehicles = snapshot.data!;
          if (selectedVehicle != null && !vehicles.contains(selectedVehicle)) {
            selectedVehicle = null;
          }

          return DropdownButtonFormField<Vehicle>(
            value: selectedVehicle,
            items: vehicles.map((Vehicle vehicle) {
              return DropdownMenuItem<Vehicle>(
                value: vehicle,
                child: Text(vehicle.type),
              );
            }).toList(),
            onChanged: (Vehicle? newValue) {
              widget.onSelected(newValue);
            },
            decoration: const InputDecoration(
              labelText: 'Select Vehicle',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null ? 'Please select a vehicle' : null,
          );
        }
      },
    );
  }
}
