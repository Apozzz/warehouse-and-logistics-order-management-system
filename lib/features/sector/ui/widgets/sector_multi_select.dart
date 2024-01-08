import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:inventory_system/features/sector/models/sector_model.dart';

class SectorMultiSelect extends StatefulWidget {
  final List<Sector> allSectors;
  final List<Sector> initialSelectedSectors;
  final Function(List<Sector>) onSelectionChanged;

  const SectorMultiSelect({
    Key? key,
    required this.allSectors,
    required this.onSelectionChanged,
    required this.initialSelectedSectors,
  }) : super(key: key);

  @override
  _SectorMultiSelectState createState() => _SectorMultiSelectState();
}

class _SectorMultiSelectState extends State<SectorMultiSelect> {
  List<Sector> selectedSectors = [];

  @override
  void initState() {
    super.initState();
    selectedSectors = widget.initialSelectedSectors;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Sector>.multiSelection(
      items: widget.allSectors,
      selectedItems: selectedSectors,
      itemAsString: (Sector sector) => sector.name,
      compareFn: (Sector item1, Sector item2) => item1.id == item2.id,
      onChanged: (List<Sector> newSelectedSectors) {
        setState(() => selectedSectors = newSelectedSectors);
        widget.onSelectionChanged(newSelectedSectors);
      },
      popupProps: const PopupPropsMultiSelection.menu(
        showSelectedItems: true,
        showSearchBox: true,
      ),
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Sectors",
          hintText: "Search and select sectors",
        ),
      ),
    );
  }
}
