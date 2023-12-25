import 'package:flutter/material.dart';
import 'package:inventory_system/features/category/models/category_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';
import 'package:inventory_system/features/category/services/category_service.dart';

class CategoryMultiSelect extends StatefulWidget {
  final List<Category> allCategories;
  final List<Category> initialSelectedCategories;
  final Function(List<Category>) onSelectionChanged;

  const CategoryMultiSelect({
    Key? key,
    required this.allCategories,
    required this.onSelectionChanged,
    required this.initialSelectedCategories,
  }) : super(key: key);

  @override
  _CategoryMultiSelectState createState() => _CategoryMultiSelectState();
}

class _CategoryMultiSelectState extends State<CategoryMultiSelect> {
  late CategoryService categoryService;
  List<Category> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    selectedCategories = widget.initialSelectedCategories;
    categoryService = Provider.of<CategoryService>(context, listen: false);
  }

  bool isCompatible(Category category) {
    // Extract IDs from the selected categories and add the new category's ID
    Set<String> selectedCategoryIds =
        selectedCategories.map((c) => c.id).toSet();

    Set<String> combinedCategoryIds = {
      ...selectedCategoryIds,
      category.id,
    };

    // Use the set of IDs to check compatibility
    return categoryService.areCategoriesCompatibleSync(combinedCategoryIds);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Category>.multiSelection(
      items: widget.allCategories, // Assuming this now has the data needed
      compareFn: (Category item1, Category item2) => item1.id == item2.id,
      selectedItems: selectedCategories,
      itemAsString: (Category category) => category.name,
      onChanged: (List<Category> selectedCategories) {
        setState(() => selectedCategories = selectedCategories);
        widget.onSelectionChanged(selectedCategories);
      },
      popupProps: PopupPropsMultiSelection.menu(
        disabledItemFn: (Category category) => !isCompatible(category),
        onItemAdded: (List<Category> selected, Category currentlySelected) {
          setState(() => selectedCategories = selected);
          widget.onSelectionChanged(selected);
        },
        onItemRemoved: (List<Category> selected, Category currentlySelected) {
          setState(() => selectedCategories = selected);
          widget.onSelectionChanged(selected);
        },
        showSelectedItems: true,
        showSearchBox: true,
      ),
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Categories",
          hintText: "Search and select categories",
        ),
      ),
    );
  }
}
