import 'package:flutter/material.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';
import 'package:inventory_system/features/order/models/order_model.dart';

class FinishedDetailsWidget extends StatelessWidget {
  final List<Order> orders;
  final String deliveryId;
  final Delivery delivery;

  const FinishedDetailsWidget({
    Key? key,
    required this.orders,
    required this.deliveryId,
    required this.delivery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery ID: $deliveryId',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text('Delivery Date: ${delivery.deliveryDate}',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),
            if (delivery.transportationDetails?.pathImageUrl != null)
              Image.network(delivery.transportationDetails!.pathImageUrl!),
            const SizedBox(height: 20),
            Text('Orders:', style: Theme.of(context).textTheme.titleLarge),
            ...orders.map(
              (order) => Card(
                child: ListTile(
                  title: Text(order.customerName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address: ${order.customerAddress}'),
                      if (order.declineReason != null &&
                          order.declineReason!.isNotEmpty)
                        Text('Decline Reason: ${order.declineReason}'),
                    ],
                  ),
                  trailing: Text('Status: ${order.status.name}'),
                  leading: order.imageUrl != null
                      ? Image.network(order.imageUrl!)
                      : null,
                  isThreeLine: order.declineReason != null &&
                      order.declineReason!.isNotEmpty,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
