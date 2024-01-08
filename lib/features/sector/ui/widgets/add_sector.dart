import 'package:flutter/material.dart';
import 'package:inventory_system/features/sector/DAOs/sector_dao.dart';
import 'package:inventory_system/features/sector/models/sector_model.dart';
import 'package:inventory_system/features/sector/ui/widgets/sector_form.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class AddSectorForm extends StatefulWidget {
  const AddSectorForm({Key? key}) : super(key: key);

  @override
  _AddSectorFormState createState() => _AddSectorFormState();
}

class _AddSectorFormState extends State<AddSectorForm> {
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
    final sectorDAO = Provider.of<SectorDAO>(context, listen: false);

    if (companyId == null) {
      return const CircularProgressIndicator();
    }

    return AddEditSectorForm(
      companyId: companyId!,
      onSubmit: (Sector sector) async {
        await sectorDAO.addSector(sector);
        Navigator.of(context).pop(); // Close the form on successful addition
      },
    );
  }
}
