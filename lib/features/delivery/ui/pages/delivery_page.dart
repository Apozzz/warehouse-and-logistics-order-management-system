import 'package:flutter/material.dart';
import 'package:inventory_system/features/delivery/ui/widgets/add_delivery_form.dart';
import 'package:inventory_system/features/delivery/ui/widgets/delivery_list.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Deliveries'),
      ),
      body: const DeliveryList(), // Delivery list widget
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDeliveryForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDeliveryForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const Material(
            child: AddDeliveryForm(), // Add delivery form widget
          ),
        );
      },
    );
  }
}
