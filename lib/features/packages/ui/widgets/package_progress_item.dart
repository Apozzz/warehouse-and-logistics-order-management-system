import 'package:flutter/material.dart';
import 'package:inventory_system/enums/package_progress_status.dart';
import 'package:inventory_system/features/packages/services/packaging_service.dart';
import 'package:inventory_system/features/product/ui/widgets/product_details_dialog.dart';
import 'package:inventory_system/features/packages/models/package_progress.dart';
import 'package:inventory_system/shared/ui/widgets/submit_decline_reason_dialog.dart';
import 'package:provider/provider.dart';

class PackageProgressItem extends StatelessWidget {
  final PackageProgress progress;
  final VoidCallback onStatusChange;

  const PackageProgressItem({
    Key? key,
    required this.progress,
    required this.onStatusChange,
  }) : super(key: key);

  Future<void> _togglePackageStatus(
      BuildContext context, PackageProgress progress) async {
    final packagingService =
        Provider.of<PackagingService>(context, listen: false);

    if (progress.status == PackageProgressStatus.Declined) {
      // Restore all packages for the order
      await packagingService.restoreAllPackagesForOrder(progress.orderId);
      onStatusChange();
    } else {
      // Decline all packages for the order after getting a reason
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) => SubmitDeclineReasonDialog(
          onSubmit: (reason) async {
            if (reason.isNotEmpty) {
              await packagingService.declineAllPackagesForOrder(
                  progress.orderId, reason);
              onStatusChange(); // Invoke callback after status change
            }
          },
          note:
              "Please note: Declining this package will affect the entire order.",
        ),
      );
    }
  }

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
      case PackageProgressStatus.Declined:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, color: statusColor),
                IconButton(
                  icon: Icon(
                    progress.status == PackageProgressStatus.Declined
                        ? Icons.undo
                        : Icons.block,
                    color: progress.status == PackageProgressStatus.Declined
                        ? Colors.green
                        : Colors.red,
                  ),
                  tooltip: progress.status == PackageProgressStatus.Declined
                      ? 'Restore Package'
                      : 'Decline Package',
                  onPressed: () async =>
                      await _togglePackageStatus(context, progress),
                )
              ],
            ),
            onTap: () => showProductDetails(context, progress.productId),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress.status == PackageProgressStatus.Declined
                        ? 1.0
                        : progressValue,
                    backgroundColor:
                        progress.status == PackageProgressStatus.Declined
                            ? Colors.red[300]
                            : Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress.status == PackageProgressStatus.Declined
                          ? Colors.red
                          : statusColor,
                    ),
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
