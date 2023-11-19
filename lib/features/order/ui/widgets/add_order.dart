import 'package:flutter/material.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/order/ui/pages/order_page.dart';
import 'package:inventory_system/features/order/ui/widgets/order_form.dart';
import 'package:inventory_system/features/product/DAOs/product_dao.dart';
import 'package:inventory_system/features/product/models/product_model.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class AddOrderForm extends StatefulWidget {
  const AddOrderForm({Key? key}) : super(key: key);

  @override
  _AddOrderFormState createState() => _AddOrderFormState();
}

class _AddOrderFormState extends State<AddOrderForm> {
  List<Product>? products;
  String? companyId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final productDAO = Provider.of<ProductDAO>(context, listen: false);

    try {
      companyId = await withCompanyId<String>(context, (id) async {
        products = await productDAO.fetchProducts(id);
        return id;
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderDAO = Provider.of<OrderDAO>(context, listen: false);
    final navigator = Navigator.of(context);

    if (isLoading) {
      return const CircularProgressIndicator();
    }

    if (products == null || companyId == null) {
      return const Text('No products available or company ID is missing.');
    }

    return OrderForm(
      companyId: companyId!,
      allProducts: products!,
      onSubmit: (order) async {
        await orderDAO.addOrder(order);
        navigator.pushReplacementNoTransition(const OrderPage());
      },
    );
  }
}
