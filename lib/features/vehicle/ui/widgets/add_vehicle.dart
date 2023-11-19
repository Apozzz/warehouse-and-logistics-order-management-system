import 'package:flutter/material.dart';
import 'package:inventory_system/features/vehicle/DAOs/vehicle_dao.dart';
import 'package:inventory_system/features/vehicle/ui/pages/vehicle_page.dart';
import 'package:inventory_system/features/vehicle/ui/widgets/vehicle_form.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class AddVehicleForm extends StatefulWidget {
  const AddVehicleForm({Key? key}) : super(key: key);

  @override
  _AddVehicleFormState createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm> {
  List<Order>? orders;
  String? companyId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final orderDAO = Provider.of<OrderDAO>(context, listen: false);

    try {
      companyId = await withCompanyId<String>(context, (id) async {
        orders = await orderDAO.fetchOrders(id);
        return id;
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleDAO = Provider.of<VehicleDAO>(context, listen: false);
    final navigator = Navigator.of(context);

    if (isLoading) {
      return const CircularProgressIndicator();
    }

    if (orders == null || companyId == null) {
      return const Text('No orders available or company ID is missing.');
    }

    return VehicleForm(
      companyId: companyId!,
      allOrders: orders!,
      onSubmit: (vehicle) async {
        await vehicleDAO.addVehicle(vehicle);
        navigator.pushReplacementNoTransition(const VehiclePage());
      },
    );
  }
}