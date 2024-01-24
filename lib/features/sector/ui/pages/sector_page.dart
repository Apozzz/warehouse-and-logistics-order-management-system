import 'package:flutter/material.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/sector/ui/widgets/add_sector.dart';
import 'package:inventory_system/features/sector/ui/widgets/sector_list.dart';
import 'package:inventory_system/shared/ui/widgets/permission_controlled_action_button.dart';

class SectorPage extends StatelessWidget {
  const SectorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          const SectorList(), // Sector list widget
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: PermissionControlledActionButton(
              appPage: AppPage.Warehouses,
              permissionType: PermissionType.Manage,
              child: FloatingActionButton(
                onPressed: () => _showAddSectorForm(context),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSectorForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const AddSectorForm(), // Add sector form widget
        );
      },
    );
  }
}
