import 'package:flutter/material.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/order/ui/widgets/edit_order.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:inventory_system/utils/pdf_generator.dart';
import 'package:provider/provider.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  late Future<List<Order>> ordersFuture;
  final PdfGenerator pdfGenerator = PdfGenerator();

  @override
  void initState() {
    super.initState();
    fetchOrdersWithCompanyId();
  }

  Future<void> fetchOrdersWithCompanyId() async {
    await withCompanyId(context, (companyId) async {
      final orderDAO = Provider.of<OrderDAO>(context, listen: false);
      ordersFuture = orderDAO.fetchOrders(companyId);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return FutureBuilder<List<Order>>(
      future: ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No orders found.'));
        }

        List<Order> orders = snapshot.data!;
        return ListView.separated(
          itemCount: orders.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final order = orders[index];
            return ListTile(
              title: Text('Order #${order.id}'),
              subtitle: Text(
                  'Total: ${order.total} - Date: ${order.createdAt.toString()}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf),
                    onPressed: () async {
                      try {
                        final path = await pdfGenerator.generateOrderPdf(order);
                        await pdfGenerator.openPdf(
                            path); // Assuming you have an openPdf method
                      } catch (e) {
                        // Handle errors
                        print("Error generating PDF: $e");
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditOrderScreen(order: order),
                        ),
                      ).then((_) {
                        fetchOrdersWithCompanyId(); // Refresh the list when returning from the edit screen
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
                            title: const Text('Delete Order'),
                            content: Text(
                                'Are you sure you want to delete Order #${order.id}?'),
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
                                    final orderDAO = Provider.of<OrderDAO>(
                                        context,
                                        listen: false);
                                    await orderDAO.deleteOrder(order.id);
                                    navigator.pop();
                                    fetchOrdersWithCompanyId(); // Refresh the list after deletion
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
