import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/features/category/services/category_service.dart';
import 'package:inventory_system/features/vehicle/models/vehicle_model.dart';
import 'package:provider/provider.dart';

class VehicleSelect extends StatefulWidget {
  final Vehicle? initialVehicle;
  final Function(Vehicle?) onSelected;
  final List<Vehicle> allVehicles;
  final Set<String> categoryIdsToCheck;

  const VehicleSelect({
    Key? key,
    this.initialVehicle,
    required this.onSelected,
    required this.allVehicles,
    required this.categoryIdsToCheck,
  }) : super(key: key);

  @override
  _VehicleSelectState createState() => _VehicleSelectState();
}

class _VehicleSelectState extends State<VehicleSelect> {
  Vehicle? selectedVehicle;
  late CategoryService categoryService;

  @override
  void initState() {
    super.initState();
    selectedVehicle = widget.initialVehicle;
    categoryService = Provider.of<CategoryService>(context, listen: false);
  }

  bool isVehicleCompatible(Vehicle vehicle) {
    var combinedCategoryIds = {
      ...vehicle.allowedCategories,
      ...widget.categoryIdsToCheck
    };
    return categoryService.areCategoriesCompatibleSync(combinedCategoryIds);
  }

  List<Vehicle> getFilteredVehicles() {
    return widget.allVehicles.where(isVehicleCompatible).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Vehicle>(
      popupProps: const PopupProps.menu(
        showSearchBox: true,
      ),
      items: getFilteredVehicles(),
      itemAsString: (Vehicle vehicle) => vehicle.type,
      onChanged: (Vehicle? newValue) {
        widget.onSelected(newValue);
      },
      selectedItem: selectedVehicle,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Vehicle",
          hintText: "Search and select vehicle",
        ),
      ),
    );
  }
}
