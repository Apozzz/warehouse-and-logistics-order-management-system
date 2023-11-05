import 'package:flutter/material.dart';
import 'package:inventory_system/features/product/ui/widgets/add_product_form.dart';
import 'package:inventory_system/features/product/ui/widgets/product_list.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: const ProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const AddProductForm();
      },
    );
  }
}
