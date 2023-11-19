import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:inventory_system/features/product/models/product_model.dart';

class ProductMultiSelect extends StatefulWidget {
  final List<Product> allProducts;
  final List<Product> initialSelectedProducts;
  final Function(List<Product>) onSelectionChanged;

  const ProductMultiSelect({
    Key? key,
    required this.allProducts,
    required this.onSelectionChanged,
    required this.initialSelectedProducts,
  }) : super(key: key);

  @override
  _ProductMultiSelectState createState() => _ProductMultiSelectState();
}

class _ProductMultiSelectState extends State<ProductMultiSelect> {
  List<Product> selectedProducts = [];

  @override
  void initState() {
    super.initState();
    selectedProducts =
        widget.initialSelectedProducts; // Initialize with initial selection
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Select Products'),
      onPressed: () => _showMultiSelect(context),
    );
  }

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<Product>(
          items: widget.allProducts
              .map((product) => MultiSelectItem<Product>(product, product.name))
              .toList(),
          initialValue: selectedProducts, // This is the key change
          onConfirm: (values) {
            setState(() {
              selectedProducts = values;
            });
            widget.onSelectionChanged(selectedProducts);
          },
        );
      },
    );
  }
}
