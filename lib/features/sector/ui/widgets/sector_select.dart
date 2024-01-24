import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/features/sector/models/sector_model.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';

class SectorSelect extends StatelessWidget {
  final Warehouse? selectedWarehouse;
  final Sector? initialSector;
  final Function(Sector?) onSectorSelected;
  final List<Sector> allSectors;

  const SectorSelect({
    Key? key,
    this.selectedWarehouse,
    required this.onSectorSelected,
    required this.allSectors,
    required this.initialSector,
  }) : super(key: key);

  List<Sector> getFilteredSectors() {
    if (selectedWarehouse == null) {
      return allSectors;
    } else {
      return allSectors
          .where((sector) => selectedWarehouse!.sectorIds.contains(sector.id))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Sector>(
      popupProps: const PopupProps.menu(
        showSearchBox: true,
      ),
      items: getFilteredSectors(),
      itemAsString: (Sector sector) => sector.name,
      onChanged: onSectorSelected,
      selectedItem: initialSector,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Sector",
          hintText: "Search and select sector",
        ),
      ),
    );
  }
}
