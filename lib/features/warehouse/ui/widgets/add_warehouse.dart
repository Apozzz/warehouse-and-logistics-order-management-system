import 'package:flutter/material.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:inventory_system/features/warehouse/ui/widgets/warehouse_form.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class AddWarehouseWidget extends StatefulWidget {
  const AddWarehouseWidget({Key? key}) : super(key: key);

  @override
  _AddWarehouseWidgetState createState() => _AddWarehouseWidgetState();
}

class _AddWarehouseWidgetState extends State<AddWarehouseWidget> {
  String? companyId;

  @override
  void initState() {
    super.initState();
    _fetchCompanyId();
  }

  Future<void> _fetchCompanyId() async {
    companyId = await withCompanyId<String>(context, (id) async {
      return id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final warehouseDAO = Provider.of<WarehouseDAO>(context, listen: false);

    if (companyId == null) {
      return const CircularProgressIndicator();
    }

    return WarehouseForm(
      companyId: companyId!,
      onSubmit: (Warehouse newWarehouse) async {
        await warehouseDAO.addWarehouse(newWarehouse);
        Navigator.of(context).pop(); // Close the form on successful addition
      },
    );
  }
}
