import 'package:flutter/material.dart';
import 'package:inventory_system/features/warehouse/services/warehouse_service.dart';
import 'package:inventory_system/utils/date_utils.dart';
import 'package:provider/provider.dart';

class AddWarehouseForm extends StatefulWidget {
  final Function onWarehouseAdded;
  const AddWarehouseForm({required this.onWarehouseAdded, super.key});

  @override
  _AddWarehouseFormState createState() => _AddWarehouseFormState();
}

class _AddWarehouseFormState extends State<AddWarehouseForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.business),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final warehouseService =
                              Provider.of<WarehouseService>(context,
                                  listen: false);
                          warehouseService.addWarehouse({
                            'name': _nameController.text,
                            'address': _addressController.text,
                            'createdAt':
                                CustomDateUtils.formatDate(DateTime.now()),
                            'companyId': 0,
                          });
                          Navigator.pop(context);
                          widget.onWarehouseAdded.call();
                        }
                      },
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: const Text('Add Warehouse'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black, // icon and text color
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
