import 'package:flutter/material.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/features/warehouse/ui/pages/warehouse_page.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
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
                        fillColor: Color.fromARGB(255, 47, 31, 31),
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
                          withCompanyId(context, (companyId) async {
                            final warehouseDAO = Provider.of<WarehouseDAO>(
                                context,
                                listen: false);
                            final newWarehouse = Warehouse(
                              id: '', // You may need to adjust this based on how you handle IDs
                              name: _nameController.text,
                              address: _addressController.text,
                              createdAt: DateTime.now(),
                              companyId: companyId,
                            );
                            warehouseDAO.addWarehouse(newWarehouse);
                            Navigator.of(context).pushReplacementNoTransition(
                                const WarehousePage());
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Warehouse'),
                      // No need for style here as it uses the theme's default style
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
