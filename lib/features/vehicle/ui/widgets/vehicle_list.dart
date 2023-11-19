import 'package:flutter/material.dart';
import 'package:inventory_system/features/vehicle/DAOs/vehicle_dao.dart';
import 'package:inventory_system/features/vehicle/models/vehicle_model.dart';
import 'package:inventory_system/features/vehicle/ui/widgets/edit_vehicle.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class VehicleList extends StatefulWidget {
  const VehicleList({Key? key}) : super(key: key);

  @override
  _VehicleListState createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  late Future<List<Vehicle>> vehiclesFuture;

  @override
  void initState() {
    super.initState();
    fetchVehiclesWithCompanyId();
  }

  Future<void> fetchVehiclesWithCompanyId() async {
    await withCompanyId(context, (companyId) async {
      final vehicleDAO = Provider.of<VehicleDAO>(context, listen: false);
      vehiclesFuture = vehicleDAO.fetchVehicles(companyId);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return FutureBuilder<List<Vehicle>>(
      future: vehiclesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No vehicles found.'));
        }

        List<Vehicle> vehicles = snapshot.data!;
        return ListView.separated(
          itemCount: vehicles.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            return ListTile(
              title: Text('Vehicle: ${vehicle.type}'),
              subtitle: Text(
                  'Reg#: ${vehicle.registrationNumber} - Max Weight: ${vehicle.maxWeight} kg'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditVehicleScreen(vehicle: vehicle),
                        ),
                      ).then((_) {
                        fetchVehiclesWithCompanyId(); // Refresh the list when returning from the edit screen
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Vehicle'),
                            content: Text(
                                'Are you sure you want to delete ${vehicle.type} with Reg#: ${vehicle.registrationNumber}?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () async {
                                  await withCompanyId<void>(context,
                                      (companyId) async {
                                    final vehicleDAO = Provider.of<VehicleDAO>(
                                        context,
                                        listen: false);
                                    await vehicleDAO.deleteVehicle(vehicle.id);
                                    navigator.pop();
                                    fetchVehiclesWithCompanyId(); // Refresh the list after deletion
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
