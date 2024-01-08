import 'package:flutter/material.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';

class WarehouseForm extends StatefulWidget {
  final Warehouse? warehouse; // Null if adding a new warehouse
  final String companyId;
  final Function(Warehouse) onSubmit;

  const WarehouseForm({
    Key? key,
    this.warehouse,
    required this.companyId,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _WarehouseFormState createState() => _WarehouseFormState();
}

class _WarehouseFormState extends State<WarehouseForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.warehouse != null) {
      // Initialize form fields with existing warehouse data
      _nameController.text = widget.warehouse!.name;
      _addressController.text = widget.warehouse!.address;
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
    return Form(
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
                    sectorIds: widget.warehouse?.sectorIds ?? {},
                  );
                  widget.onSubmit(newWarehouse);
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
