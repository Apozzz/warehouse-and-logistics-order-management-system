import 'package:flutter/material.dart';
import 'package:inventory_system/features/sector/DAOs/sector_dao.dart';
import 'package:inventory_system/features/sector/models/sector_model.dart';
import 'package:inventory_system/features/sector/ui/widgets/sector_form.dart';
import 'package:provider/provider.dart';

class EditSectorScreen extends StatefulWidget {
  final Sector sector;

  const EditSectorScreen({Key? key, required this.sector}) : super(key: key);

  @override
  _EditSectorScreenState createState() => _EditSectorScreenState();
}

class _EditSectorScreenState extends State<EditSectorScreen> {
  @override
  void initState() {
    super.initState();
    // Any initialization if required
  }

  @override
  Widget build(BuildContext context) {
    final sectorDAO = Provider.of<SectorDAO>(context, listen: false);

    return Material(
      child: AddEditSectorForm(
        sector: widget.sector,
        companyId: widget.sector.companyId,
        onSubmit: (updatedSector) async {
          await sectorDAO.updateSector(widget.sector.id, updatedSector.toMap());
          Navigator.of(context).pop(); // Go back after updating sector
        },
      ),
    );
  }
}
