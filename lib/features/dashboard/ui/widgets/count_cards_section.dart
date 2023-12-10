import 'package:flutter/material.dart';
import 'package:inventory_system/features/dashboard/model/dashboard_data.dart';
import 'package:inventory_system/features/dashboard/ui/widgets/count_card.dart';

class CountCardsSection extends StatelessWidget {
  final DashboardData data;

  const CountCardsSection({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: <Widget>[
        CountCard(title: 'Total Orders', count: data.totalOrders),
        CountCard(title: 'Total Deliveries', count: data.totalDeliveries),
        CountCard(title: 'Total Products', count: data.totalProducts),
        CountCard(title: 'Total Users', count: data.totalUsers),
        // Add more CountCards as needed
      ],
    );
  }
}
