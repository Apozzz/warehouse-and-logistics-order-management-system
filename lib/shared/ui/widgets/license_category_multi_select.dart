import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:inventory_system/enums/driving_category.dart';

class LicenseCategoryMultiSelect extends StatefulWidget {
  final Set<DrivingLicenseCategory> initialSelectedCategories;
  final Function(Set<DrivingLicenseCategory>) onSelectionChanged;

  const LicenseCategoryMultiSelect({
    Key? key,
    required this.initialSelectedCategories,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _LicenseCategoryMultiSelectState createState() =>
      _LicenseCategoryMultiSelectState();
}

class _LicenseCategoryMultiSelectState
    extends State<LicenseCategoryMultiSelect> {
  Set<DrivingLicenseCategory> selectedCategories = {};

  @override
  void initState() {
    super.initState();
    selectedCategories = widget.initialSelectedCategories;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<DrivingLicenseCategory>.multiSelection(
      items: DrivingLicenseCategory.values.toList(),
      selectedItems: selectedCategories.toList(),
      itemAsString: (DrivingLicenseCategory category) =>
          category.toString().split('.').last,
      onChanged: (List<DrivingLicenseCategory> newSelectedCategories) {
        setState(() => selectedCategories = newSelectedCategories.toSet());
        widget.onSelectionChanged(newSelectedCategories.toSet());
      },
      compareFn: (item1, item2) => item1 == item2,
      popupProps: const PopupPropsMultiSelection.menu(
        showSelectedItems: true,
        showSearchBox:
            false, // Typically you wouldn't need a search box for a finite list of categories
        title: Text("Select License Categories"),
      ),
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select License Categories",
          hintText: "Select multiple license categories",
        ),
      ),
    );
  }
}
