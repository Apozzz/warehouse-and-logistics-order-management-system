import 'package:flutter/material.dart';
import 'package:inventory_system/enums/order_status.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/packages/ui/widgets/decline_reason_dialog.dart';

class OrderCard extends StatefulWidget {
  final Order order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late Order order;

  @override
  void initState() {
    super.initState();
    order = widget.order;
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.Delivered:
        return Colors.green;
      case OrderStatus.Pending:
        return Colors.orange;
      case OrderStatus.InTransit:
        return Colors.blue;
      case OrderStatus.Failed:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(2.0),
      child: ListTile(
        leading: Icon(Icons.circle, color: _getStatusColor(order.status)),
        title: Text('Order ID: ${order.id}'),
        subtitle: Text(
            'Customer: ${order.customerName}\nAddress: ${order.customerAddress}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show info button only for Declined orders
            if (order.status == OrderStatus.Failed)
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => DeclineReasonDialog(
                        declineReason:
                            order.declineReason ?? "No reason provided"),
                  );
                },
              ),
          ],
        ),
        onTap: () {
          // Action for tapping on card
        },
      ),
    );
  }
}
