import 'package:flutter/material.dart';
import 'package:inventory_system/features/delivery/DAOs/delivery_dao.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';
import 'package:inventory_system/features/delivery/ui/widgets/edit_delivery_form.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
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
              trailing: Row(
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
                                  await withCompanyId<void>(context,
                                      (companyId) async {
                                    final deliveryDAO =
                                        Provider.of<DeliveryDAO>(context,
                                            listen: false);
                                    await deliveryDAO
                                        .deleteDelivery(delivery.id);
                                    navigator.pop();
                                    fetchDeliveriesWithCompanyId(); // Refresh the list after deletion
                                  });
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
            );
          },
        );
      },
    );
  }
}
