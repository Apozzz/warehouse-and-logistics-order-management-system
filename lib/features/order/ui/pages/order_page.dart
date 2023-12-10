import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/order/ui/widgets/add_order.dart';
import 'package:inventory_system/features/order/ui/widgets/order_list.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: const OrderList(),
      floatingActionButton: PermissionControlledActionButton(
        appPage: AppPage.Orders, // Specify the AppPage for the delivery
        permissionType: PermissionType.Manage, // Specify the permission type
        child: FloatingActionButton(
          onPressed: () {
            _showAddOrderForm(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddOrderForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const Material(
            child: AddOrderForm(),
          ),
        );
      },
    );
  }
}
