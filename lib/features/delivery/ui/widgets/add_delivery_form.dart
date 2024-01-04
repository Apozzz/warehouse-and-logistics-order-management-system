import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/delivery/DAOs/delivery_dao.dart';
import 'package:inventory_system/features/delivery/ui/widgets/delivery_form.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/vehicle/DAOs/vehicle_dao.dart';
import 'package:inventory_system/features/vehicle/models/vehicle_model.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class AddDeliveryForm extends StatefulWidget {
  const AddDeliveryForm({super.key});

  @override
  _AddDeliveryFormState createState() => _AddDeliveryFormState();
}

class _AddDeliveryFormState extends State<AddDeliveryForm> {
  List<Vehicle>? vehicles;
  List<Order>? orders;
  String? companyId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final vehicleDAO = Provider.of<VehicleDAO>(context, listen: false);
    final orderDAO = Provider.of<OrderDAO>(context, listen: false);

    try {
      companyId = await withCompanyId<String>(context, (id) async {
        vehicles = await vehicleDAO.fetchVehicles(id);
        orders = await orderDAO.fetchOrders(id);
        return id; // Return the companyId to be used in the state
      });
    } catch (e) {
      // Handle any exceptions here
    } finally {
      // Ensures the UI is rebuilt with new data or error message
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    if (isLoading) {
      return const CircularProgressIndicator();
    }

    if (vehicles == null || orders == null || companyId == null) {
      return const Text('Data loading error or missing company ID.');
    }

    return DeliveryForm(
      companyId: companyId!,
      allOrders: orders!,
      allVehicles: vehicles!,
      onSubmit: (delivery) async {
        navigator.pushReplacementNamedNoTransition(RoutePaths.deliveries);
      },
    );
  }
}
