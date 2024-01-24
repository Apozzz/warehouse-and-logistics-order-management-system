import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';

class WarehouseSelect extends StatefulWidget {
  final Warehouse? initialWarehouse;
  final Function(Warehouse?) onWarehouseSelected;
  final List<Warehouse> allWarehouses;

  const WarehouseSelect({
    Key? key,
    this.initialWarehouse,
    required this.onWarehouseSelected,
    required this.allWarehouses,
  }) : super(key: key);

  @override
  _WarehouseSelectState createState() => _WarehouseSelectState();
}

class _WarehouseSelectState extends State<WarehouseSelect> {
  Warehouse? selectedWarehouse;

  @override
  void initState() {
    super.initState();
    selectedWarehouse = widget.initialWarehouse;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Warehouse>(
      popupProps: const PopupProps.menu(
        showSearchBox: true,
      ),
      items: widget.allWarehouses,
      itemAsString: (Warehouse warehouse) => warehouse.name,
      onChanged: (Warehouse? newValue) {
        widget.onWarehouseSelected(newValue);
      },
      selectedItem: selectedWarehouse,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Warehouse",
          hintText: "Search and select warehouse",
        ),
      ),
    );
  }
}
