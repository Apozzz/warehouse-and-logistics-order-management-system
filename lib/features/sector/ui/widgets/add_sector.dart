import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/sector/DAOs/sector_dao.dart';
import 'package:inventory_system/features/sector/models/sector_model.dart';
import 'package:inventory_system/features/sector/ui/widgets/sector_form.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class AddSectorForm extends StatefulWidget {
  const AddSectorForm({Key? key}) : super(key: key);

  @override
  _AddSectorFormState createState() => _AddSectorFormState();
}

class _AddSectorFormState extends State<AddSectorForm> {
  late Future<String?> companyIdFuture;

  @override
  void initState() {
    super.initState();
    companyIdFuture = _fetchCompanyId();
  }

  Future<String?> _fetchCompanyId() async {
    return await withCompanyId<String>(context, (id) async {
      return id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sectorDAO = Provider.of<SectorDAO>(context, listen: false);

    return FutureBuilder<String?>(
      future: companyIdFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData && snapshot.data != null) {
          return AddEditSectorForm(
            companyId: snapshot.data!,
            onSubmit: (Sector sector) async {
              await sectorDAO.addSector(sector);
              Navigator.of(context).pushReplacementNamedNoTransition(
                  RoutePaths.warehouses,
                  arguments: 1); // Close the form on successful addition
            },
          );
        }
        return const Text('Company ID not found');
      },
    );
  }
}
