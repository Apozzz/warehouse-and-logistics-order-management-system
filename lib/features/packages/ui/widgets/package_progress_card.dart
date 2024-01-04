import 'package:flutter/material.dart';
import 'package:inventory_system/features/packages/models/package_progress.dart';

class PackageProgressCard extends StatelessWidget {
  final PackageProgress progress;

  const PackageProgressCard({Key? key, required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Customized card for each package's progress
    return Card(
      child: Column(
        children: [
          Text('Delivery ID: ${progress.deliveryId}'),
          Text('Order ID: ${progress.orderId}'),
          Text('Driver ID: ${progress.userId}'),
          // Display other details like quantity, packagedQuantity, status, etc.
        ],
      ),
    );
  }
}
