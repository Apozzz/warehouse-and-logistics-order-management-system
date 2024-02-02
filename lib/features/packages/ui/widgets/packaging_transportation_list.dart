import 'package:flutter/material.dart';
import 'package:inventory_system/enums/delivery_status.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';
import 'package:inventory_system/features/notification/services/notification_service.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/packages/services/packaging_service.dart';
import 'package:inventory_system/features/packages/ui/pages/package_finished_detail_page.dart';
import 'package:inventory_system/features/packages/ui/pages/package_progress_page.dart';
import 'package:inventory_system/features/packages/ui/pages/package_transport_detail_page.dart';
import 'package:inventory_system/features/user/DAOs/user_dao.dart';
import 'package:inventory_system/features/user/models/user_model.dart';
import 'package:inventory_system/features/vehicle/DAOs/vehicle_dao.dart';
import 'package:inventory_system/features/vehicle/models/vehicle_model.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
import 'package:inventory_system/utils/pdf_generator.dart';
import 'package:provider/provider.dart';

class PackagingTransportationList extends StatelessWidget {
  final bool canViewAll;
  final TabController tabController;

  const PackagingTransportationList({
    Key? key,
    required this.canViewAll,
    required this.tabController,
  }) : super(key: key);

  Future<List<Delivery>> fetchDeliveriesWithCriteria(
      BuildContext context) async {
    final companyId =
        Provider.of<CompanyProvider>(context, listen: false).companyId;
    final userId = canViewAll
        ? null
        : Provider.of<AuthViewModel>(context, listen: false).currentUser?.uid;

    if (companyId == null) return Future.value([]);

    final packagingService =
        Provider.of<PackagingService>(context, listen: false);

    // Check the current tab index and fetch the relevant data
    switch (tabController.index) {
      case 0:
        // Fetch packaging deliveries
        return packagingService.fetchPackagingDeliveries(companyId,
            userId: userId);
      case 1:
        // Fetch transit deliveries
        return packagingService.fetchTransportingDeliveries(companyId,
            userId: userId);
      case 2:
        return packagingService.fetchFinishedDeliveries(companyId,
            userId: userId);
      default:
        return Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final PdfGenerator pdfGenerator = PdfGenerator();
    final notification =
        Provider.of<NotificationService>(context, listen: false);

    return FutureBuilder<List<dynamic>>(
      future: fetchDeliveriesWithCriteria(
          context), // This will change based on the selected tab
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No records found.'));
        }

        // Here you would return a list view or another appropriate widget
        // that displays the data fetched for the current tab.
        // This is where you integrate your existing list building logic.

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            // Build list item based on the data type (Packaging or Delivery)
            var dataItem = snapshot.data![index];
            return ListTile(
              title: Text('Delivery ID: ${dataItem.id}'),
              subtitle: Text('Status: ${dataItem.status}'),
              trailing: dataItem.status == DeliveryStatus.Delivered
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.picture_as_pdf),
                          onPressed: () async {
                            try {
                              // Fetch Orders
                              final orderDAO =
                                  Provider.of<OrderDAO>(context, listen: false);
                              List<Order> orders = await orderDAO
                                  .fetchOrdersByIds(dataItem.orderIds);

                              // Fetch Vehicle
                              final vehicleDAO = Provider.of<VehicleDAO>(
                                  context,
                                  listen: false);
                              Vehicle vehicle = await vehicleDAO
                                  .getVehicleById(dataItem.vehicleId);

                              // Fetch User
                              final userDAO =
                                  Provider.of<UserDAO>(context, listen: false);
                              User user =
                                  await userDAO.getUser(dataItem.userId);

                              // Generate and open PDF
                              final path =
                                  await pdfGenerator.generateTransportationPdf(
                                dataItem,
                                orders,
                                vehicle,
                                user,
                                (String pdfPath) {
                                  notification.showNotification(
                                    0,
                                    'PDF Downloaded',
                                    'Your Delivery PDF has been downloaded.',
                                  );
                                  pdfGenerator.openPdf(pdfPath);
                                },
                              );
                              await pdfGenerator.openPdf(path);
                            } catch (e) {
                              // Handle errors
                              print("Error generating PDF: $e");
                            }
                          },
                        ),
                      ],
                    )
                  : null,
              onTap: () {
                switch (tabController.index) {
                  case 0:
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PackageProgressPage(deliveryId: dataItem.id),
                    ));
                    break;
                  case 1:
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PackageTransportDetailPage(deliveryId: dataItem.id),
                    ));
                    break;
                  case 2:
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PackageFinishedDetailPage(deliveryId: dataItem.id),
                    ));
                  default:
                    // Handle the default case or do nothing
                    break;
                }
              },
            );
          },
        );
      },
    );
  }
}
