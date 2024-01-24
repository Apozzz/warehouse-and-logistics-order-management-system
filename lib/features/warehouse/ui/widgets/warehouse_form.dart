import 'package:flutter/material.dart';
import 'package:inventory_system/features/sector/models/sector_model.dart';
import 'package:inventory_system/features/sector/ui/widgets/sector_multi_select.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';

class WarehouseForm extends StatefulWidget {
  final Warehouse? warehouse; // Null if adding a new warehouse
  final String companyId;
  final Function(Warehouse) onSubmit;
  final List<Sector> allSectors;

  const WarehouseForm({
    Key? key,
    this.warehouse,
    required this.companyId,
    required this.onSubmit,
    required this.allSectors,
  }) : super(key: key);

  @override
  _WarehouseFormState createState() => _WarehouseFormState();
}

class _WarehouseFormState extends State<WarehouseForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  List<Sector> _selectedSectors = [];

  @override
  void initState() {
    super.initState();
    if (widget.warehouse != null) {
      // Initialize form fields with existing warehouse data
      _nameController.text = widget.warehouse!.name;
      _addressController.text = widget.warehouse!.address;
      // Initialize the selected sectors if editing a warehouse
      _selectedSectors = widget.allSectors
          .where((sector) => widget.warehouse!.sectorIds.contains(sector.id))
          .toList();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Warehouse Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a warehouse name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              SectorMultiSelect(
                allSectors: widget.allSectors,
                initialSelectedSectors: _selectedSectors,
                onSelectionChanged: (List<Sector> newSelectedSectors) {
                  setState(() {
                    _selectedSectors = newSelectedSectors;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newWarehouse = Warehouse(
                      id: widget.warehouse?.id ??
                          '', // Keep existing ID if editing
                      name: _nameController.text,
                      address: _addressController.text,
                      createdAt: widget.warehouse?.createdAt ?? DateTime.now(),
                      companyId: widget.companyId,
                      sectorIds:
                          _selectedSectors.map((sector) => sector.id).toSet(),
                    );
                    widget.onSubmit(newWarehouse);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
