import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:inventory_system/features/order/models/order_model.dart';

class OrderMultiSelect extends StatefulWidget {
  final List<Order> allOrders;
  final List<Order> initialSelectedOrders;
  final Function(List<Order>) onSelectionChanged;

  const OrderMultiSelect({
    Key? key,
    required this.allOrders,
    required this.onSelectionChanged,
    required this.initialSelectedOrders,
  }) : super(key: key);

  @override
  _OrderMultiSelectState createState() => _OrderMultiSelectState();
}

class _OrderMultiSelectState extends State<OrderMultiSelect> {
  List<Order> selectedOrders = [];

  @override
  void initState() {
    super.initState();
    selectedOrders = widget.initialSelectedOrders;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Select Orders'),
      onPressed: () => _showMultiSelect(context),
    );
  }

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<Order>(
          items: widget.allOrders
              .map((order) => MultiSelectItem<Order>(order,
                  order.customerName)) // Displaying orders by customer name
              .toList(),
          initialValue: selectedOrders,
          onConfirm: (values) {
            setState(() {
              selectedOrders = values;
            });
            widget.onSelectionChanged(selectedOrders);
          },
        );
      },
    );
  }
}
