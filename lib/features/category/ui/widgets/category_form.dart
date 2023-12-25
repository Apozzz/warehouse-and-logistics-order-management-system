import 'package:flutter/material.dart';
import 'package:inventory_system/features/category/models/category_model.dart';
import 'package:inventory_system/features/category/ui/widgets/category_multi_select.dart';

class CategoryForm extends StatefulWidget {
  final Category? category; // Null if adding a new category
  final String companyId;
  final List<Category> allCategories;
  final Function(Category) onSubmit;

  const CategoryForm({
    Key? key,
    this.category,
    required this.companyId,
    required this.allCategories,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  List<Category> _selectedIncompatibleCategories = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _selectedIncompatibleCategories = mapCategoryIdsToCategories(
          widget.category!.incompatibleCategories, widget.allCategories);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  List<Category> mapCategoryIdsToCategories(
      List<String> categoryIds, List<Category> allCategories) {
    return allCategories
        .where((category) => categoryIds.contains(category.id))
        .toList();
  }

  List<Category> getFilteredCategories() {
    if (widget.category == null) {
      return widget.allCategories;
    }

    // Filter out the current category
    return widget.allCategories
        .where((cat) => cat.id != widget.category!.id)
        .toList();
  }

  Set<String> getCategoryIds() {
    return _selectedIncompatibleCategories.map((e) => e.id).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a category name';
                }
                return null;
              },
            ),
            CategoryMultiSelect(
              allCategories: getFilteredCategories(),
              initialSelectedCategories: _selectedIncompatibleCategories,
              onSelectionChanged: (selectedCategories) {
                setState(() {
                  _selectedIncompatibleCategories = selectedCategories;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final incompatibleCategoryIds =
                      _selectedIncompatibleCategories
                          .map((category) => category.id)
                          .toList();
                  final newCategory = Category(
                    id: widget.category?.id ??
                        '', // Keep existing ID if editing
                    companyId: widget.companyId,
                    name: _nameController.text,
                    incompatibleCategories: incompatibleCategoryIds,
                  );
                  widget.onSubmit(newCategory);
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
