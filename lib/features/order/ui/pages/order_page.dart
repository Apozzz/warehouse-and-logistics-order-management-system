import 'package:flutter/material.dart';
import 'package:inventory_system/features/order/ui/widgets/add_order.dart';
import 'package:inventory_system/features/order/ui/widgets/order_list.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: const OrderList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOrderForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddOrderForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const Material(
            child: AddOrderForm(),
          ),
        );
      },
    );
  }
}
