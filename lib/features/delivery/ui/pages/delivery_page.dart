import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/delivery/ui/widgets/add_delivery_form.dart';
import 'package:inventory_system/features/delivery/ui/widgets/delivery_list.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Deliveries'),
      ),
      body: const DeliveryList(), // Delivery list widget
      floatingActionButton: PermissionControlledActionButton(
        appPage: AppPage.Delivery, // Specify the AppPage for the delivery
        permissionType: PermissionType.Manage, // Specify the permission type
        child: FloatingActionButton(
          onPressed: () {
            _showAddDeliveryForm(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddDeliveryForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const Material(
            child: AddDeliveryForm(), // Add delivery form widget
          ),
        );
      },
    );
  }
}
