import 'package:flutter/material.dart';
import 'package:inventory_system/features/order/models/oraderitem_model.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/product/models/product_model.dart';
import 'package:inventory_system/features/order/ui/widgets/product_multi_select.dart';

class OrderForm extends StatefulWidget {
  final Order? order; // Null if adding a new order
  final String companyId;
  final List<Product> allProducts;
  final Function(Order) onSubmit;

  const OrderForm({
    Key? key,
    this.order,
    required this.allProducts,
    required this.companyId,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerAddressController = TextEditingController();
  List<OrderItem> _selectedOrderItems = [];
  List<Product> _selectedProducts = [];

  @override
  void initState() {
    super.initState();
    if (widget.order != null) {
      _customerNameController.text = widget.order!.customerName;
      _customerAddressController.text = widget.order!.customerAddress;

      // Initialize _selectedOrderItems from widget.order
      _selectedOrderItems = widget.order!.items.map((orderItem) {
        final product = widget.allProducts.firstWhere(
          (p) => p.id == orderItem.productId,
          orElse: () => Product.empty(),
        );
        return OrderItem(
          productId: orderItem.productId,
          quantity: orderItem.quantity,
          price: product.price,
        );
      }).toList();

      // Initialize _selectedProducts based on _selectedOrderItems
      _selectedProducts = _selectedOrderItems.map((orderItem) {
        return widget.allProducts.firstWhere(
          (product) => product.id == orderItem.productId,
          orElse: () => Product.empty(),
        );
      }).toList();
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerAddressController.dispose();
    super.dispose();
  }

  void _onProductSelectionChanged(List<Product> selectedProducts) {
    setState(() {
      _selectedProducts = selectedProducts;

      _selectedOrderItems = selectedProducts.map((product) {
        var existingItem = _selectedOrderItems.firstWhere(
          (item) => item.productId == product.id,
          orElse: () => OrderItem.empty(),
        );

        return existingItem.productId.isNotEmpty
            ? existingItem // Use existing OrderItem if found
            : OrderItem(
                productId: product.id,
                quantity: 1,
                price: product.price,
              ); // New product selected
      }).toList();
    });
  }

  double _calculateTotal() {
    return _selectedOrderItems.fold(
        0.0, (total, item) => total + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _customerNameController,
              decoration: const InputDecoration(labelText: 'Customer Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter customer name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _customerAddressController,
              decoration: const InputDecoration(labelText: 'Customer Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter customer address';
                }
                return null;
              },
            ),
            ProductMultiSelect(
              allProducts: widget.allProducts,
              onSelectionChanged: _onProductSelectionChanged,
              initialSelectedProducts:
                  _selectedProducts, // Ensure this is used correctly inside the widget
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final order = Order(
                    id: widget.order?.id ?? '', // Keep existing ID if editing
                    companyId: widget.companyId,
                    createdAt: widget.order?.createdAt ?? DateTime.now(),
                    items: _selectedOrderItems,
                    customerName: _customerNameController.text,
                    customerAddress: _customerAddressController.text,
                    total: _calculateTotal(),
                  );
                  widget.onSubmit(order);
                  Navigator.pop(context);
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
