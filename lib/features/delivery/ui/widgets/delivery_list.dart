import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/delivery/DAOs/delivery_dao.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';
import 'package:inventory_system/features/delivery/ui/widgets/edit_delivery_form.dart';
import 'package:inventory_system/features/packages/DAOs/package_progress_dao.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';
import 'package:provider/provider.dart';

class DeliveryList extends StatefulWidget {
  const DeliveryList({Key? key}) : super(key: key);

  @override
  _DeliveryListState createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  late Future<List<Delivery>> deliveriesFuture;

  @override
  void initState() {
    super.initState();
    fetchDeliveriesWithCompanyId();
  }

  Future<void> fetchDeliveriesWithCompanyId() async {
    await withCompanyId(context, (companyId) async {
      final deliveryDAO = Provider.of<DeliveryDAO>(context, listen: false);
      deliveriesFuture = deliveryDAO.fetchDeliveries(companyId);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return FutureBuilder<List<Delivery>>(
      future: deliveriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No deliveries found.'));
        }

        List<Delivery> deliveries = snapshot.data!;
        return ListView.separated(
          itemCount: deliveries.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final delivery = deliveries[index];
            return ListTile(
              title: Text('Delivery ID: ${delivery.id}'),
              subtitle: Text(
                  'Order IDs: ${delivery.orderIds.join(", ")} - Status: ${delivery.status}'),
              trailing: PermissionControlledActionButton(
                appPage: AppPage.Delivery,
                permissionType: PermissionType.Manage,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditDeliveryScreen(delivery: delivery),
                          ),
                        ).then((_) {
                          fetchDeliveriesWithCompanyId(); // Refresh the list when returning from the edit screen
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete Delivery'),
                              content: Text(
                                  'Are you sure you want to delete delivery with ID: ${delivery.id}?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () async {
                                    try {
                                      // Attempt to delete package progress associated with the delivery
                                      final packageProgressDAO =
                                          Provider.of<PackageProgressDAO>(
                                              context,
                                              listen: false);
                                      await packageProgressDAO
                                          .deletePackageProgressByDeliveryId(
                                              delivery.id);

                                      // Proceed with deleting the delivery
                                      final deliveryDAO =
                                          Provider.of<DeliveryDAO>(context,
                                              listen: false);
                                      await deliveryDAO
                                          .deleteDelivery(delivery.id);

                                      navigator.pop(); // Close the dialog
                                      fetchDeliveriesWithCompanyId(); // Refresh the list after deletion
                                    } catch (e) {
                                      navigator.pop(); // Close the dialog
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
