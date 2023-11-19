import 'package:flutter/material.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/order/ui/pages/order_page.dart';
import 'package:inventory_system/features/order/ui/widgets/order_form.dart';
import 'package:inventory_system/features/product/DAOs/product_dao.dart';
import 'package:inventory_system/features/product/models/product_model.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class EditOrderScreen extends StatefulWidget {
  final Order order;

  const EditOrderScreen({Key? key, required this.order}) : super(key: key);

  @override
  _EditOrderScreenState createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  List<Product>? products;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final productDAO = Provider.of<ProductDAO>(context, listen: false);

    await withCompanyId<void>(context, (companyId) async {
      products = await productDAO.fetchProducts(companyId);
    });

    setState(() {
      products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderDAO = Provider.of<OrderDAO>(context, listen: false);
    final navigator = Navigator.of(context);

    if (products == null) {
      return const CircularProgressIndicator();
    }

    return Material(
      child: OrderForm(
        order: widget.order,
        allProducts: products!,
        companyId: widget.order.companyId,
        onSubmit: (updatedOrder) async {
          await orderDAO.updateOrder(widget.order.id, updatedOrder.toMap());
          navigator.pushReplacementNoTransition(
              const OrderPage()); // Go back after updating order
        },
      ),
    );
  }
}
