import 'package:flutter/material.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class WarehouseSelector extends StatefulWidget {
  final Warehouse? initialWarehouse;
  final Function(Warehouse?) onSelected;

  const WarehouseSelector({
    this.initialWarehouse,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  _WarehouseSelectorState createState() => _WarehouseSelectorState();
}

class _WarehouseSelectorState extends State<WarehouseSelector> {
  Warehouse? selectedWarehouse;

  @override
  void initState() {
    super.initState();
    selectedWarehouse = widget.initialWarehouse;
  }

  @override
  Widget build(BuildContext context) {
    final warehouseDAO = Provider.of<WarehouseDAO>(context, listen: false);

    return FutureBuilder<List<Warehouse>?>(
      future: withCompanyId(
          context, (companyId) => warehouseDAO.fetchWarehouses(companyId)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return const Text('No warehouses available.');
        } else {
          return DropdownButtonFormField<Warehouse>(
            value: selectedWarehouse,
            items: snapshot.data!.map((Warehouse warehouse) {
              return DropdownMenuItem<Warehouse>(
                value: warehouse,
                child: Text(warehouse.name),
              );
            }).toList(),
            onChanged: (Warehouse? newValue) {
              setState(() {
                selectedWarehouse = newValue;
                widget.onSelected(newValue);
              });
            },
            decoration: const InputDecoration(
              labelText: 'Warehouse',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null) {
                return 'Please select a warehouse';
              }
              return null;
            },
          );
        }
      },
    );
  }
}
