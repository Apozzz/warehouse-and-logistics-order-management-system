import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/features/warehouse/ui/pages/warehouse_page.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class EditWarehouseScreen extends StatefulWidget {
  final Warehouse warehouse;

  const EditWarehouseScreen({super.key, required this.warehouse});

  @override
  _EditWarehouseScreenState createState() => _EditWarehouseScreenState();
}

class _EditWarehouseScreenState extends State<EditWarehouseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.warehouse.name;
    _addressController.text = widget.warehouse.address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.warehouse.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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
              const SizedBox(height: 10),
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Assuming you have a method in your context to get the companyId
                    withCompanyId(context, (companyId) async {
                      final updatedWarehouse = Warehouse(
                        id: widget.warehouse.id,
                        name: _nameController.text,
                        address: _addressController.text,
                        createdAt: widget.warehouse.createdAt,
                        companyId:
                            companyId, // Here you get the companyId from context
                      );
                      final warehouseDAO =
                          Provider.of<WarehouseDAO>(context, listen: false);
                      // Now, call the update method on your service with the companyId
                      await warehouseDAO.updateWarehouse(
                          updatedWarehouse.id, updatedWarehouse.toMap());
                    });
                    Navigator.of(context).pushReplacementNamedNoTransition(
                        RoutePaths.warehouses);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
