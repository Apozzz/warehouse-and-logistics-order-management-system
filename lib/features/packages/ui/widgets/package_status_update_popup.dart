import 'package:flutter/material.dart';
import 'package:inventory_system/enums/order_status.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/order/ui/widgets/order_selector.dart';
import 'package:inventory_system/features/order/ui/widgets/order_status_selector.dart';
import 'dart:io';

import 'package:inventory_system/utils/image_capture.dart';

class StatusUpdatePopup extends StatefulWidget {
  final List<Order> orders;
  final Function(Order, OrderStatus, String?, File?) onStatusUpdated;

  const StatusUpdatePopup({
    Key? key,
    required this.orders,
    required this.onStatusUpdated,
  }) : super(key: key);

  @override
  _StatusUpdatePopupState createState() => _StatusUpdatePopupState();
}

class _StatusUpdatePopupState extends State<StatusUpdatePopup> {
  Order? selectedOrder;
  OrderStatus? selectedStatus;
  TextEditingController declineReasonController = TextEditingController();
  File? capturedImage;

  @override
  void initState() {
    super.initState();
    selectedOrder = widget.orders.isNotEmpty ? widget.orders.first : null;
    selectedStatus =
        selectedOrder != null ? selectedOrder!.status : OrderStatus.InTransit;
  }

  Future<void> _captureDeliveryImage() async {
    capturedImage = await ImageCapture.captureImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Order Status'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            OrderSelect(
              initialOrder: selectedOrder,
              onOrderSelected: (Order? order) {
                setState(() {
                  selectedOrder = order;
                  selectedStatus = order!.status;
                });
              },
              allOrders: widget.orders,
            ),
            const SizedBox(height: 16),
            OrderStatusSelect(
              status: selectedStatus,
              onStatusSelected: (OrderStatus? status) {
                setState(() => selectedStatus = status);
              },
            ),
            if (selectedStatus == OrderStatus.Failed)
              TextField(
                controller: declineReasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason for Declining',
                  hintText: 'Enter a reason',
                ),
              ),
            if (selectedStatus == OrderStatus.Delivered &&
                capturedImage == null)
              ElevatedButton(
                onPressed: _captureDeliveryImage,
                child: const Text('Capture Delivery Image'),
              ),
            if (capturedImage != null)
              Column(
                children: [
                  const SizedBox(height: 10),
                  Image.file(capturedImage!),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _captureDeliveryImage,
                    child: const Text('Retake Image'),
                  ),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (selectedStatus == OrderStatus.Delivered &&
                capturedImage == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Image has to be taken on Delivered status."),
                ),
              );
              return;
            }

            Navigator.of(context).pop();

            widget.onStatusUpdated(
              selectedOrder!,
              selectedStatus!,
              declineReasonController.text,
              capturedImage,
            );
          },
          child: const Text('Update Status'),
        ),
      ],
    );
  }
}
