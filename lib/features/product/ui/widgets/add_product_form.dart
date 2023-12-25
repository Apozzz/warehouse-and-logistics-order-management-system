import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/category/DAOs/category_dao.dart';
import 'package:inventory_system/features/category/models/category_model.dart';
import 'package:inventory_system/features/product/DAOs/product_dao.dart';
import 'package:inventory_system/features/product/ui/widgets/product_form.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  List<Warehouse>? warehouses;
  List<Category>? categories;
  String? companyId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final warehouseDAO = Provider.of<WarehouseDAO>(context, listen: false);
    final categoryDAO = Provider.of<CategoryDAO>(context, listen: false);

    try {
      // Assuming withCompanyId will throw if companyId is null or not found.
      companyId = await withCompanyId<String>(context, (id) async {
        // Now that we have the companyId, let's fetch the warehouses
        warehouses = await warehouseDAO.fetchWarehouses(id);
        categories = await categoryDAO.fetchCategories(id);
        return id; // Return the companyId to be used in the state
      });
    } finally {
      // Ensures the UI is rebuilt with new data or error message
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productDAO = Provider.of<ProductDAO>(context, listen: false);
    final navigator = Navigator.of(context);

    if (isLoading) {
      return const CircularProgressIndicator();
    }

    if (warehouses == null || companyId == null || categories == null) {
      return const Text('Data missing or not available.');
    }

    return ProductForm(
      warehouses: warehouses!,
      companyId: companyId!,
      categories: categories!,
      onSubmit: (product) async {
        await productDAO.addProduct(product);
        navigator.pushReplacementNamedNoTransition(RoutePaths.products);
      },
    );
  }
}
