import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/enums/driving_category.dart';

class LicenseCategorySelect extends StatefulWidget {
  final DrivingLicenseCategory? initialCategory;
  final Function(DrivingLicenseCategory?) onSelected;

  const LicenseCategorySelect({
    Key? key,
    this.initialCategory,
    required this.onSelected,
  }) : super(key: key);

  @override
  _LicenseCategorySelectState createState() => _LicenseCategorySelectState();
}

class _LicenseCategorySelectState extends State<LicenseCategorySelect> {
  DrivingLicenseCategory? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<DrivingLicenseCategory>(
      popupProps: const PopupProps.menu(
        showSearchBox:
            false, // Typically you wouldn't need a search box for a finite list of categories
      ),
      items: DrivingLicenseCategory.values,
      itemAsString: (DrivingLicenseCategory category) =>
          category.toString().split('.').last,
      onChanged: (DrivingLicenseCategory? newValue) {
        setState(() {
          selectedCategory = newValue;
        });
        widget.onSelected(newValue);
      },
      compareFn: (item1, item2) => item1 == item2,
      selectedItem: selectedCategory,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select License Category",
          hintText: "Select license category",
        ),
      ),
    );
  }
}
