import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/dashboard/model/dashboard_data.dart';
import 'package:inventory_system/features/dashboard/services/dashboard_data_service.dart';
import 'package:inventory_system/features/dashboard/ui/widgets/bar_charts_section.dart';
import 'package:inventory_system/features/dashboard/ui/widgets/count_cards_section.dart';
import 'package:inventory_system/features/dashboard/ui/widgets/line_charts_section.dart';
import 'package:inventory_system/features/dashboard/ui/widgets/pie_charts_section.dart';
import 'package:inventory_system/features/product/DAOs/product_dao.dart';
import 'package:inventory_system/features/product/models/product_model.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';
import 'package:inventory_system/utils/barcode_scanner.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardDataService =
        Provider.of<DashboardDataService>(context, listen: false);

    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: FutureBuilder<DashboardData>(
        future: dashboardDataService.getDashboardData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while waiting for the data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle error scenario
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            // Handle no data scenario
            return const Center(child: Text('No data available'));
          }

          // If we have data, build the UI with CountCards
          final data = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                CountCardsSection(data: data),
                LineChartsSection(data: data),
                PieChartsSection(data: data),
                BarChartsSection(data: data),
                // Add more sections as needed
              ],
            ),
          );
        },
      ),
      floatingActionButton: PermissionControlledActionButton(
        appPage: AppPage.Dashboard, // Specify the page
        permissionType: PermissionType.Manage, // Specify the permission type
        child: FloatingActionButton(
            onPressed: () => _scanAndShowProduct(context),
            child: const Icon(Icons.camera_alt)),
      ),
    );
  }

  Future<void> _scanAndShowProduct(BuildContext context) async {
    final barcode = await BarcodeScanner.scanBarcode(context);
    if (barcode != null) {
      final product = await _getProductByBarcode(barcode, context);
      if (product != null) {
        _showProductDetails(context, product);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No product found with barcode: $barcode')),
        );
      }
    }
  }

  Future<Product?> _getProductByBarcode(
      String barcode, BuildContext context) async {
    final productDAO = Provider.of<ProductDAO>(context, listen: false);
    return await productDAO.getProductByBarcode(barcode);
  }

  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product.name),
          content: Text('Description: ${product.description}\n'
              'Price: ${product.price}\n'
              'Quantity: ${product.quantity}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
