import 'package:flutter/material.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/features/warehouse/ui/widgets/warehouse_form.dart';
import 'package:provider/provider.dart';

class EditWarehouseWidget extends StatefulWidget {
  final Warehouse warehouse;

  const EditWarehouseWidget({Key? key, required this.warehouse})
      : super(key: key);

  @override
  _EditWarehouseWidgetState createState() => _EditWarehouseWidgetState();
}

class _EditWarehouseWidgetState extends State<EditWarehouseWidget> {
  @override
  Widget build(BuildContext context) {
    final warehouseDAO = Provider.of<WarehouseDAO>(context, listen: false);

    return WarehouseForm(
      warehouse: widget.warehouse,
      companyId: widget.warehouse.companyId,
      onSubmit: (Warehouse updatedWarehouse) async {
        await warehouseDAO.updateWarehouse(
            updatedWarehouse.id, updatedWarehouse.toMap());
        Navigator.of(context).pop(); // Go back after updating warehouse
      },
    );
  }
}
