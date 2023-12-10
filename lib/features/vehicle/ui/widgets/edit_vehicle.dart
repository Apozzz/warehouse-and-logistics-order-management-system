import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/vehicle/DAOs/vehicle_dao.dart';
import 'package:inventory_system/features/vehicle/models/vehicle_model.dart';
import 'package:inventory_system/features/vehicle/ui/pages/vehicle_page.dart';
import 'package:inventory_system/features/vehicle/ui/widgets/vehicle_form.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class EditVehicleScreen extends StatefulWidget {
  final Vehicle vehicle;

  const EditVehicleScreen({Key? key, required this.vehicle}) : super(key: key);

  @override
  _EditVehicleScreenState createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  List<Order>? orders;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final orderDAO = Provider.of<OrderDAO>(context, listen: false);

    await withCompanyId<void>(context, (companyId) async {
      orders = await orderDAO.fetchOrders(companyId);
    });

    setState(() {
      orders = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehicleDAO = Provider.of<VehicleDAO>(context, listen: false);
    final navigator = Navigator.of(context);

    if (orders == null) {
      return const CircularProgressIndicator();
    }

    return Material(
      child: VehicleForm(
        vehicle: widget.vehicle,
        allOrders: orders!,
        companyId: widget.vehicle.companyId,
        onSubmit: (updatedVehicle) async {
          await vehicleDAO.updateVehicle(
              widget.vehicle.id, updatedVehicle.toMap());
          navigator.pushReplacementNamedNoTransition(
              RoutePaths.vehicles); // Go back after updating vehicle
        },
      ),
    );
  }
}
