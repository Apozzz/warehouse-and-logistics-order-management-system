import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/sector/DAOs/sector_dao.dart';
import 'package:inventory_system/features/sector/models/sector_model.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/features/warehouse/ui/widgets/warehouse_form.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class AddWarehouseWidget extends StatefulWidget {
  const AddWarehouseWidget({Key? key}) : super(key: key);

  @override
  _AddWarehouseWidgetState createState() => _AddWarehouseWidgetState();
}

class _AddWarehouseWidgetState extends State<AddWarehouseWidget> {
  late Future<String?> companyIdFuture;
  List<Sector>? sectors;

  @override
  void initState() {
    super.initState();
    companyIdFuture = _fetchCompanyId();
  }

  Future<String?> _fetchCompanyId() async {
    final sectorDAO = Provider.of<SectorDAO>(context, listen: false);

    return await withCompanyId<String>(context, (id) async {
      sectors = await sectorDAO.fetchSectors(id);
      return id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final warehouseDAO = Provider.of<WarehouseDAO>(context, listen: false);

    return FutureBuilder<String?>(
      future: companyIdFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return WarehouseForm(
            companyId: snapshot.data!,
            allSectors: sectors!,
            onSubmit: (Warehouse newWarehouse) async {
              await warehouseDAO.addWarehouse(newWarehouse);
              Navigator.of(context).pushReplacementNamedNoTransition(RoutePaths
                  .warehouses); // Close the form on successful addition
            },
          );
        }
        return const Text('Company ID not found');
      },
    );
  }
}
