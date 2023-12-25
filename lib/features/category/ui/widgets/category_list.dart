import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/category/DAOs/category_dao.dart';
import 'package:inventory_system/features/category/models/category_model.dart';
import 'package:inventory_system/features/category/ui/widgets/edit_category.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  late Future<List<Category>> categoriesFuture;

  @override
  void initState() {
    super.initState();
    fetchCategoriesWithCompanyId();
  }

  Future<void> fetchCategoriesWithCompanyId() async {
    await withCompanyId(context, (companyId) async {
      final categoryDAO = Provider.of<CategoryDAO>(context, listen: false);
      categoriesFuture = categoryDAO.fetchCategories(companyId);
      setState(() {});
    });
  }

  String _getIncompatibleCategories(
      List<Category> categories, Category category) {
    String incompatibleCategoryNames = '';

    for (var incompatibleCategoryId in category.incompatibleCategories) {
      final incompatibleCategory = categories.firstWhere(
        (cat) => cat.id == incompatibleCategoryId,
        orElse: () => Category.empty(),
      );
      if (incompatibleCategory != Category.empty()) {
        if (incompatibleCategoryNames.isNotEmpty) {
          incompatibleCategoryNames += ', ';
        }
        incompatibleCategoryNames += incompatibleCategory.name;
      }
    }

    return incompatibleCategoryNames;
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return FutureBuilder<List<Category>>(
      future: categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories found.'));
        }

        List<Category> categories = snapshot.data!;
        return ListView.separated(
          itemCount: categories.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final category = categories[index];

            return ListTile(
              title: Text(category.name),
              subtitle: Text(
                  'Non-Compatible: ${_getIncompatibleCategories(categories, category)}'),
              trailing: PermissionControlledActionButton(
                appPage: AppPage.Categories,
                permissionType: PermissionType.Manage,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pushReplacementWidgetNoTransition(
                            EditCategory(category: category));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete Category'),
                              content: Text(
                                  'Are you sure you want to delete ${category.name}?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () async {
                                    final categoryDAO =
                                        Provider.of<CategoryDAO>(context,
                                            listen: false);
                                    await categoryDAO
                                        .deleteCategory(category.id);
                                    navigator.pop();
                                    fetchCategoriesWithCompanyId(); // Refresh the list after deletion
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
        );
      },
    );
  }
}
