import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/category/DAOs/category_dao.dart';
import 'package:inventory_system/features/category/models/category_model.dart';
import 'package:inventory_system/features/category/ui/widgets/category_form.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:provider/provider.dart';

class EditCategory extends StatefulWidget {
  final Category category;

  const EditCategory({Key? key, required this.category}) : super(key: key);

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategory> {
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories();
  }

  Future<List<Category>> _fetchCategories() async {
    final categoryDAO = Provider.of<CategoryDAO>(context, listen: false);
    return categoryDAO.fetchCategories(widget.category.companyId);
  }

  @override
  Widget build(BuildContext context) {
    final categoryDAO = Provider.of<CategoryDAO>(context, listen: false);

    return FutureBuilder<List<Category>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const Text('No categories available.');
        }

        List<Category> allCategories = snapshot.data!;
        return BaseScaffold(
          body: CategoryForm(
            category: widget.category,
            allCategories: allCategories,
            companyId: widget.category.companyId,
            onSubmit: (updatedCategory) async {
              await categoryDAO.updateCategory(
                  widget.category.id, updatedCategory.toMap());
              Navigator.of(context).pushReplacementNamedNoTransition(
                  RoutePaths.categories); // Go back after updating category
            },
          ),
        );
      },
    );
  }
}
