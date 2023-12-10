import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/product/DAOs/product_dao.dart';
import 'package:inventory_system/features/product/models/product_model.dart';
import 'package:inventory_system/features/product/ui/widgets/edit_product_form.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late Future<List<Product>> productsFuture;

  @override
  void initState() {
    super.initState();
    fetchProductsWithCompanyId();
  }

  Future<void> fetchProductsWithCompanyId() async {
    withCompanyId(context, (companyId) async {
      final productDAO = Provider.of<ProductDAO>(context, listen: false);
      productsFuture = productDAO.fetchProducts(companyId);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return FutureBuilder(
      future: productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData ||
            (snapshot.data as List<Product>).isEmpty) {
          return const Center(child: Text('No products found.'));
        } else {
          List<Product> products = snapshot.data as List<Product>;
          return ListView.separated(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
                trailing: PermissionControlledActionButton(
                  appPage: AppPage.Products,
                  permissionType: PermissionType.Manage,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProductScreen(product: product),
                            ),
                          ).then((_) {
                            fetchProductsWithCompanyId(); // Refresh the list when returning from the edit screen
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete Product'),
                                content: Text(
                                    'Are you sure you want to delete ${product.name}?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      withCompanyId(context, (companyId) async {
                                        final productDAO =
                                            Provider.of<ProductDAO>(context,
                                                listen: false);
                                        await productDAO
                                            .deleteProduct(product.id);
                                        navigator.pop();
                                        fetchProductsWithCompanyId(); // Refresh the list after deletion
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        }
      },
    );
  }
}
