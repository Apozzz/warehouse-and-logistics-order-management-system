import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';
import 'package:inventory_system/features/packages/services/packaging_service.dart';
import 'package:inventory_system/features/packages/ui/pages/package_progress_page.dart';
import 'package:inventory_system/features/packages/ui/pages/package_transport_detail_page.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
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
      default:
        return Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onTap: () {
                if (tabController.index == 0) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PackageProgressPage(deliveryId: dataItem.id),
                  ));
                } else if (tabController.index == 1) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PackageTransportDetailPage(deliveryId: dataItem.id),
                  ));
                }
              },
            );
          },
        );
      },
    );
  }
}
