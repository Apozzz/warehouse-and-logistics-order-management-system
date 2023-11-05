import 'package:flutter/material.dart';
import 'package:inventory_system/features/product/models/product_model.dart';
import 'package:inventory_system/features/product/ui/widgets/warehouse_selector.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/utils/barcode_scanner.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final List<Warehouse> warehouses;
  final Function(Product) onSubmit;

  const ProductForm({
    required this.onSubmit,
    required this.warehouses,
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
  Warehouse? selectedWarehouse;

  @override
  void initState() {
    super.initState();
    final product = widget.product ?? Product.empty();
    _nameController.text = product.name;
    _descriptionController.text = product.description;
    _barcodeController.text = product.scanCode;
    _priceController.text = product.price.toString();
    _quantityController.text = product.quantity.toString();
    if (product.warehouseId != null) {
      selectedWarehouse = widget.warehouses.firstWhere(
          (warehouse) => warehouse.id == product.warehouseId,
          orElse: () => Warehouse.empty());
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
    return Form(
      key: _formKey,
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
              if (barcode != null) {
                _barcodeController.text = barcode;
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
          WarehouseSelector(
            onSelected: (Warehouse? warehouse) {
              selectedWarehouse = warehouse;
            },
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
                  warehouseId: selectedWarehouse?.id,
                  quantity: int.parse(_quantityController.text),
                  createdAt: widget.product?.createdAt ??
                      DateTime
                          .now(), // Use existing createdAt or current time if it's a new product
                  companyId: widget.product?.companyId ??
                      '', // Use existing companyId or empty string if it's a new product
                );

                widget.onSubmit(
                    product); // Call onSubmit callback with the created product
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
