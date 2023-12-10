import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/product/DAOs/product_dao.dart';
import 'package:inventory_system/features/product/models/product_model.dart';
import 'package:inventory_system/features/product/ui/pages/product_page.dart';
import 'package:inventory_system/features/product/ui/widgets/product_form.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  List<Warehouse>? warehouses;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final warehouseDAO = Provider.of<WarehouseDAO>(context, listen: false);

    await withCompanyId<void>(context, (companyId) async {
      warehouses = await warehouseDAO.fetchWarehouses(companyId);
    });

    setState(() {
      warehouses = warehouses;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productDAO = Provider.of<ProductDAO>(context, listen: false);
    final navigator = Navigator.of(context);

    if (warehouses == null) {
      return const CircularProgressIndicator();
    }

    return Material(
      child: ProductForm(
        warehouses: warehouses!,
        product: widget.product,
        companyId: widget.product.companyId,
        onSubmit: (updatedProduct) async {
          await productDAO.updateProduct(
              widget.product.id, updatedProduct.toMap());
          navigator.pushReplacementNamedNoTransition(RoutePaths.products);
        },
      ),
    );
  }
}
