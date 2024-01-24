import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inventory_system/features/dashboard/model/dashboard_data.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/delivery/DAOs/delivery_dao.dart';
import 'package:inventory_system/features/product/DAOs/product_dao.dart';
import 'package:inventory_system/features/user/DAOs/user_dao.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';
// ... other necessary imports

class DashboardDataService {
  Future<DashboardData> getDashboardData(BuildContext context) async {
    final orderDAO = Provider.of<OrderDAO>(context, listen: false);
    final deliveryDAO = Provider.of<DeliveryDAO>(context, listen: false);
    final productDAO = Provider.of<ProductDAO>(context,
        listen: false); // Assume you have a ProductDAO
    final userDAO = Provider.of<UserDAO>(context,
        listen: false); // Assume you have a UserDAO

    // Use a Completer to manage the asynchronous operation
    Completer<DashboardData> dataCompleter = Completer();

    // Call the withCompanyId function
    withCompanyId(context, (companyId) async {
      final results = await Future.wait([
        orderDAO.getTotalOrders(companyId),
        deliveryDAO.getTotalDeliveries(companyId),
        productDAO.getTotalProducts(companyId),
        userDAO.getTotalUsers(companyId),
        // ... other async operations
      ]); // Implement this method in UserDAO
      // Once both asynchronous operations are complete, complete the future
      dataCompleter.complete(DashboardData(
        totalOrders: results[0],
        totalDeliveries: results[1],
        totalProducts: results[2],
        totalUsers: results[3],
        // ... assign other results
      ));
    });

    // Wait for the completer to complete and return its future
    return dataCompleter.future;
  }
}
