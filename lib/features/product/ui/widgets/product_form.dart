import 'package:flutter/material.dart';
import 'package:inventory_system/features/category/models/category_model.dart';
import 'package:inventory_system/features/category/ui/widgets/category_multi_select.dart';
import 'package:inventory_system/features/product/models/product_model.dart';
import 'package:inventory_system/features/warehouse/ui/widgets/warehouse_selector.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/utils/barcode_scanner.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final String companyId;
  final List<Warehouse> warehouses;
  final List<Category> categories; // Add this line
  final Function(Product) onSubmit;

  const ProductForm({
    required this.onSubmit,
    required this.warehouses,
    required this.categories, // Add this line
    required this.companyId,
    this.product,
    Key? key,
  }) : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  Warehouse? _selectedWarehouse;
  List<Category> _selectedCategories = []; // Add this line

  @override
  void initState() {
    super.initState();
    final product = widget.product ?? Product.empty();

    if (widget.product != null) {
      _nameController.text = product.name;
      _descriptionController.text = product.description;
      _barcodeController.text = product.scanCode;
      _priceController.text = product.price.toString();
      _quantityController.text = product.quantity.toString();
      _selectedWarehouse =
          (product.warehouseId != null && product.warehouseId!.isNotEmpty)
              ? widget.warehouses.firstWhere((v) => v.id == product.warehouseId,
                  orElse: () => Warehouse.empty())
              : (widget.warehouses.isNotEmpty
                  ? widget.warehouses.first
                  : Warehouse.empty());
      _selectedCategories = widget.categories
          .where((category) => widget.product!.categories.contains(category.id))
          .toList();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _barcodeController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottomPadding + 20),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final barcode = await BarcodeScanner.scanBarcode(context);
                if (barcode != null && barcode != '-1') {
                  _barcodeController.text = barcode;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Scanned barcode: $barcode')),
                  );
                  print('Scanned barcode: $barcode');
                } else if (barcode == '-1') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Barcode scanning cancelled')),
                  );
                  print('Barcode scanning cancelled');
                }
              },
              child: const Text('Scan Barcode'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quantity';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            WarehouseSelect(
              initialWarehouse: _selectedWarehouse,
              onSelected: (Warehouse? warehouse) {
                _selectedWarehouse = warehouse;
              },
            ),
            const SizedBox(height: 20),
            CategoryMultiSelect(
              allCategories: widget.categories,
              onSelectionChanged: (List<Category> selectedCategories) {
                setState(() {
                  _selectedCategories = selectedCategories;
                });
              },
              initialSelectedCategories: _selectedCategories,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final product = Product(
                    id: widget.product?.id ??
                        '', // Use existing ID or empty string if it's a new product
                    name: _nameController.text,
                    description: _descriptionController.text,
                    scanCode: _barcodeController.text,
                    price: double.parse(_priceController.text),
                    warehouseId: _selectedWarehouse?.id,
                    quantity: int.parse(_quantityController.text),
                    createdAt: widget.product?.createdAt ??
                        DateTime
                            .now(), // Use existing createdAt or current time if it's a new product
                    companyId: widget
                        .companyId, // Use existing companyId or empty string if it's a new product
                    categories: _selectedCategories.map((c) => c.id).toSet(),
                  );

                  widget.onSubmit(
                      product); // Call onSubmit callback with the created product
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
