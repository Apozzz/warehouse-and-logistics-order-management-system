import 'package:flutter/material.dart';
import 'package:inventory_system/enums/order_status.dart';

class OrderStatusLeadingIcon extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusLeadingIcon({Key? key, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == OrderStatus.Failed) {
      return const Tooltip(
        message: 'Urgent: This order has failed and needs immediate attention',
        child: Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
    // Optionally, add more icons for other statuses if needed
    return const SizedBox
        .shrink(); // Return an empty widget for statuses without a specific icon
  }
}
