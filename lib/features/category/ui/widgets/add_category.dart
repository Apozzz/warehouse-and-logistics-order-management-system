import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/category/DAOs/category_dao.dart';
import 'package:inventory_system/features/category/models/category_model.dart';
import 'package:inventory_system/features/category/ui/widgets/category_form.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  late Future<List<Category>> _categoriesFuture;
  String? _companyId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final categoryDAO = Provider.of<CategoryDAO>(context, listen: false);

    try {
      _companyId = await _getCompanyId(context); // Method to get companyId
      _categoriesFuture = categoryDAO.fetchCategories(_companyId!);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _getCompanyId(BuildContext context) async {
    final companyId = await withCompanyId<String>(context, (id) async {
      return id;
    });

    return companyId!;
  }

  @override
  Widget build(BuildContext context) {
    final categoryDAO = Provider.of<CategoryDAO>(context, listen: false);

    if (_isLoading) {
      return const CircularProgressIndicator();
    }

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
        return CategoryForm(
          companyId: _companyId!,
          allCategories: allCategories,
          onSubmit: (newCategory) async {
            await categoryDAO.addCategory(newCategory);
            Navigator.of(context)
                .pushReplacementNamedNoTransition(RoutePaths.categories);
          },
        );
      },
    );
  }
}
