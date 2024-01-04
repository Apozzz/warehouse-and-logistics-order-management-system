import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';
import 'package:inventory_system/features/packages/DAOs/package_progress_dao.dart';
import 'package:inventory_system/features/packages/models/package_progress.dart';
import 'package:inventory_system/features/packages/services/packaging_service.dart';
import 'package:inventory_system/features/packages/ui/pages/package_progress_page.dart';
import 'package:inventory_system/features/packages/ui/widgets/package_progress_card.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
import 'package:provider/provider.dart';

class PackageProgressList extends StatelessWidget {
  final bool canViewAll;

  const PackageProgressList({Key? key, required this.canViewAll})
      : super(key: key);

  Future<List<Delivery>> fetchDeliveriesWithCriteria(
      BuildContext context) async {
    final companyId =
        Provider.of<CompanyProvider>(context, listen: false).companyId;
    final userId = canViewAll
        ? null
        : Provider.of<AuthViewModel>(context, listen: false).currentUser?.uid;

    // Use the updated service method with optional userId
    return companyId != null
        ? Provider.of<PackagingService>(context, listen: false)
            .fetchPackagingDeliveries(companyId, userId: userId)
        : Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Delivery>>(
      future: fetchDeliveriesWithCriteria(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No deliveries found.'));
        }

        List<Delivery> deliveries = snapshot.data!;
        return ListView.separated(
          itemCount: deliveries.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final delivery = deliveries[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementWidgetNoTransition(
                    PackageProgressPage(deliveryId: delivery.id));
              },
              child: ListTile(
                title: Text('Delivery ID: ${delivery.id}'),
                subtitle: Text('Status: ${delivery.status}'),
                // Add other details you want to display
              ),
            );
          },
        );
      },
    );
  }
}
