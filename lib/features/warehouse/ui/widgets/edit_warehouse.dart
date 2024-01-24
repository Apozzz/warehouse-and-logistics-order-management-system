import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/sector/DAOs/sector_dao.dart';
import 'package:inventory_system/features/sector/models/sector_model.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/features/warehouse/ui/widgets/warehouse_form.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:provider/provider.dart';

class EditWarehouseWidget extends StatefulWidget {
  final Warehouse warehouse;

  const EditWarehouseWidget({Key? key, required this.warehouse})
      : super(key: key);

  @override
  _EditWarehouseWidgetState createState() => _EditWarehouseWidgetState();
}

class _EditWarehouseWidgetState extends State<EditWarehouseWidget> {
  List<Sector>? sectors;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final sectorDAO = Provider.of<SectorDAO>(context, listen: false);

    sectors = await sectorDAO.fetchSectors(widget.warehouse.companyId);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final warehouseDAO = Provider.of<WarehouseDAO>(context, listen: false);

    if (isLoading) {
      return const CircularProgressIndicator();
    }

    if (sectors == null) {
      return const Text('Sectors data missing or not available.');
    }

    return WarehouseForm(
      warehouse: widget.warehouse,
      companyId: widget.warehouse.companyId,
      allSectors: sectors!,
      onSubmit: (Warehouse updatedWarehouse) async {
        await warehouseDAO.updateWarehouse(
            updatedWarehouse.id, updatedWarehouse.toMap());
        Navigator.of(context).pushReplacementNamedNoTransition(
            RoutePaths.warehouses,
            arguments: 0); // Go back after updating warehouse
      },
    );
  }
}
