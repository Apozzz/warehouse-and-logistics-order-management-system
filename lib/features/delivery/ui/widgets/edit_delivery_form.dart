import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/delivery/DAOs/delivery_dao.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';
import 'package:inventory_system/features/delivery/ui/pages/delivery_page.dart';
import 'package:inventory_system/features/delivery/ui/widgets/delivery_form.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/vehicle/DAOs/vehicle_dao.dart';
import 'package:inventory_system/features/vehicle/models/vehicle_model.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class EditDeliveryScreen extends StatefulWidget {
  final Delivery delivery;

  const EditDeliveryScreen({Key? key, required this.delivery})
      : super(key: key);

  @override
  _EditDeliveryScreenState createState() => _EditDeliveryScreenState();
}

class _EditDeliveryScreenState extends State<EditDeliveryScreen> {
  List<Order>? allOrders;
  List<Vehicle>? allVehicles;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final orderDAO = Provider.of<OrderDAO>(context, listen: false);
    final vehicleDAO = Provider.of<VehicleDAO>(context, listen: false);

    await withCompanyId<void>(context, (companyId) async {
      allOrders = await orderDAO.fetchOrders(companyId);
      allVehicles = await vehicleDAO.fetchVehicles(companyId);
    });

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deliveryDAO = Provider.of<DeliveryDAO>(context, listen: false);
    final navigator = Navigator.of(context);

    if (isLoading) {
      return const CircularProgressIndicator();
    }

    if (allOrders == null || allVehicles == null) {
      return const Text('Data not available.');
    }

    return Material(
      child: DeliveryForm(
        delivery: widget.delivery,
        companyId: widget.delivery.companyId,
        allOrders: allOrders!,
        allVehicles: allVehicles!,
        onSubmit: (updatedDelivery) async {
          await deliveryDAO.updateDelivery(
              updatedDelivery.id, updatedDelivery.toMap());
          navigator.pushReplacementNamedNoTransition(RoutePaths.deliveries);
        },
      ),
    );
  }
}
