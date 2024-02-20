import 'package:flutter/material.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/packages/ui/widgets/finished_details_widget.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:provider/provider.dart';

class PackageFinishedDetailPage extends StatelessWidget {
  final String deliveryId;
  final Delivery
      delivery; // Assume this object contains all the necessary details
  final List<String>
      orderIds; // Assume this list contains both delivered and failed orders

  const PackageFinishedDetailPage({
    Key? key,
    required this.deliveryId,
    required this.delivery,
    required this.orderIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Finished Deliveries Detail'),
      ),
      body: FutureBuilder<List<Order>>(
        future: Provider.of<OrderDAO>(context, listen: false)
            .fetchOrdersByIds(orderIds),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            List<Order> orders = snapshot.data!;
            return FinishedDetailsWidget(
              orders: orders,
              deliveryId: deliveryId,
              delivery: delivery,
            );
          } else {
            return const Center(child: Text('No orders found.'));
          }
        },
      ),
    );
  }
}
