import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/category/ui/widgets/add_category.dart';
import 'package:inventory_system/features/category/ui/widgets/category_list.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: const CategoryList(), // Category list widget
      floatingActionButton: PermissionControlledActionButton(
        appPage: AppPage.Categories, // Specify the AppPage for categories
        permissionType: PermissionType.Manage,
        child: FloatingActionButton(
          onPressed: () {
            _showAddCategoryForm(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddCategoryForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const Material(
            child: AddCategory(), // Add category form widget
          ),
        );
      },
    );
  }
}
