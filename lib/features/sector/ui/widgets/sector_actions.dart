import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/sector/DAOs/sector_dao.dart';
import 'package:inventory_system/features/sector/models/sector_model.dart';
import 'package:inventory_system/features/sector/ui/widgets/edit_sector.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';
import 'package:provider/provider.dart';

class SectorActions extends StatelessWidget {
  final Sector sector;

  const SectorActions({Key? key, required this.sector}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _editButton(context),
        _deleteButton(context),
      ],
    );
  }

  Widget _editButton(BuildContext context) {
    return PermissionControlledActionButton(
      appPage: AppPage.Warehouses,
      permissionType: PermissionType.Manage,
      child: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditSectorScreen(sector: sector),
            ),
          );
        },
      ),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return PermissionControlledActionButton(
      appPage: AppPage.Warehouses,
      permissionType: PermissionType.Manage,
      child: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _confirmDelete(context),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Sector'),
          content: Text(
              'Are you sure you want to delete the sector: ${sector.name}?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await _deleteSector(context);
                Navigator.of(context).pushReplacementNamedNoTransition(
                    RoutePaths.warehouses,
                    arguments: 1); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSector(BuildContext context) async {
    await withCompanyId<void>(context, (companyId) async {
      final sectorDAO = Provider.of<SectorDAO>(context, listen: false);
      await sectorDAO.deleteSector(sector.id);
    });
  }
}
