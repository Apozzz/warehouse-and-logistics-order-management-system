import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inventory_system/enums/order_status.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/packages/ui/widgets/package_status_update_popup.dart';
import 'package:inventory_system/shared/services/images_service.dart';
import 'package:provider/provider.dart';

class OrderStatusFloatingActionButton extends StatelessWidget {
  final bool isDeliveryInProgress;
  final List<Order> orders;
  final VoidCallback refreshOrders;

  const OrderStatusFloatingActionButton({
    Key? key,
    required this.isDeliveryInProgress,
    required this.orders,
    required this.refreshOrders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isDeliveryInProgress
        ? FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => StatusUpdatePopup(
                  orders: orders,
                  onStatusUpdated: (Order updatedOrder, OrderStatus newStatus,
                      String? reason, File? imageFile) async {
                    final orderDAO =
                        Provider.of<OrderDAO>(context, listen: false);
                    final imageService =
                        Provider.of<ImageService>(context, listen: false);
                    String? imageUrl;

                    if (newStatus == OrderStatus.Delivered &&
                        imageFile != null) {
                      imageUrl = await imageService.uploadImage(
                          imageFile, 'orderImages/${updatedOrder.id}.png');
                    }

                    updatedOrder = updatedOrder.copyWith(
                      status: newStatus,
                      declineReason: reason,
                      imageUrl: imageUrl,
                    );
                    await orderDAO.updateOrder(
                        updatedOrder.id, updatedOrder.toMap());

                    refreshOrders();
                  },
                ),
              );
            },
            child: const Icon(Icons.edit),
          )
        : FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.play_arrow),
          );
  }
}
