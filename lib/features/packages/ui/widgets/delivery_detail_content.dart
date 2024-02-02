import 'package:flutter/material.dart';
import 'package:inventory_system/enums/delivery_status.dart';
import 'package:inventory_system/enums/order_status.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';
import 'package:inventory_system/features/google_maps/ui/widgets/google_map_widget.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/packages/ui/widgets/package_order_card.dart';

class DeliveryDetailContent extends StatelessWidget {
  final List<Order> deliveryOrders;
  final bool isDeliveryInProgress;
  final VoidCallback onStartDelivery;
  final VoidCallback onEndDelivery;
  final bool showMap;
  final List<String> orderAddresses;
  final Delivery delivery;

  const DeliveryDetailContent({
    Key? key,
    required this.deliveryOrders,
    required this.isDeliveryInProgress,
    required this.onStartDelivery,
    required this.onEndDelivery,
    required this.showMap,
    required this.orderAddresses,
    required this.delivery,
  }) : super(key: key);

  bool canEndDelivery() {
    // For testing just return always true.
    return true;

    // Check if all orders are either Delivered or Failed
    return deliveryOrders.every((order) =>
        order.status == OrderStatus.Delivered ||
        order.status == OrderStatus.Failed);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Delivery ID: ${delivery.id}',
            style: Theme.of(context).textTheme.titleLarge),
        Expanded(
          child: ListView.builder(
            itemCount: deliveryOrders.length,
            itemBuilder: (context, index) {
              Order order = deliveryOrders[index];
              return OrderCard(order: order);
            },
          ),
        ),
        const SizedBox(height: 20),
        if (!isDeliveryInProgress &&
            delivery.status != DeliveryStatus.Delivered)
          ElevatedButton(
            onPressed: onStartDelivery,
            child: const Text('Start Delivery'),
          ),
        if (isDeliveryInProgress)
          ElevatedButton(
            onPressed: () {
              if (canEndDelivery()) {
                onEndDelivery();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        "Ensure all orders are delivered or failed before ending delivery."),
                  ),
                );
              }
            },
            child: const Text('End Delivery'),
          ),
        const SizedBox(height: 20),
        if (showMap)
          Expanded(child: GoogleMapWidget(addresses: orderAddresses)),
      ],
    );
  }
}
