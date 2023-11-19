import 'package:flutter/material.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class WarehouseSelect extends StatefulWidget {
  final Warehouse? initialWarehouse;
  final Function(Warehouse?) onSelected;

  const WarehouseSelect({
    Key? key,
    this.initialWarehouse,
    required this.onSelected,
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
    return FutureBuilder<List<Warehouse>?>(
      future: withCompanyId(
        context,
        (companyId) => Provider.of<WarehouseDAO>(context, listen: false)
            .fetchWarehouses(companyId),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No warehouses available.');
        } else {
          List<Warehouse> warehouses = snapshot.data!;

          if (selectedWarehouse != null &&
              !warehouses.contains(selectedWarehouse)) {
            selectedWarehouse = null;
          }

          return DropdownButtonFormField<Warehouse>(
            value: selectedWarehouse,
            items: warehouses.map((Warehouse warehouse) {
              return DropdownMenuItem<Warehouse>(
                value: warehouse,
                child: Text(warehouse.name),
              );
            }).toList(),
            onChanged: (Warehouse? newValue) {
              widget.onSelected(newValue);
            },
            decoration: const InputDecoration(
              labelText: 'Select Warehouse',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null ? 'Please select a warehouse' : null,
          );
        }
      },
    );
  }
}
