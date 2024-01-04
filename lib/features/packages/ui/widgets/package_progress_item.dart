import 'package:flutter/material.dart';
import 'package:inventory_system/enums/package_progress_status.dart';
import 'package:inventory_system/features/product/ui/widgets/product_details_dialog.dart';
import 'package:inventory_system/features/packages/models/package_progress.dart';

class PackageProgressItem extends StatelessWidget {
  final PackageProgress progress;

  const PackageProgressItem({Key? key, required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    double progressValue =
        (progress.packagedQuantity / progress.quantity).clamp(0.0, 1.0);

    switch (progress.status) {
      case PackageProgressStatus.NotStarted:
        statusColor = Colors.grey;
        statusIcon = Icons.radio_button_unchecked;
        break;
      case PackageProgressStatus.InProgress:
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        break;
      case PackageProgressStatus.Packaged:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.error;
    }

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Order ID: ${progress.orderId}'),
            subtitle: Text('Product ID: ${progress.productId}'),
            trailing: Icon(statusIcon, color: statusColor),
            onTap: () => showProductDetails(context, progress.productId),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child:
                      Text('${progress.packagedQuantity}/${progress.quantity}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
