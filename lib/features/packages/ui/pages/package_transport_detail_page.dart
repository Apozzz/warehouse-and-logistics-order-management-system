import 'package:flutter/material.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';

class PackageTransportDetailPage extends StatelessWidget {
  final String deliveryId;

  const PackageTransportDetailPage({Key? key, required this.deliveryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Transport Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Delivery ID: $deliveryId',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for button action
                print('Button Pressed');
              },
              child: const Text('Action Button'),
            ),
          ],
        ),
      ),
    );
  }
}