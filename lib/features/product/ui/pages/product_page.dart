import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/product/ui/widgets/add_product_form.dart';
import 'package:inventory_system/features/product/ui/widgets/product_list.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: const ProductList(),
      floatingActionButton: PermissionControlledActionButton(
        appPage: AppPage.Products, // Specify the AppPage for the delivery
        permissionType: PermissionType.Manage,
        child: FloatingActionButton(
          onPressed: () {
            _showAddProductForm(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddProductForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // You can return your form here
        return Padding(
          padding: MediaQuery.of(context)
              .viewInsets, // This will give padding relative to the keyboard
          child: const Material(
            child: AddProductForm(), // Your form widget
          ),
        );
      },
    );
  }
}
