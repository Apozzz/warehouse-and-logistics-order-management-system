import 'package:flutter/material.dart';
import 'package:inventory_system/features/sector/DAOs/sector_dao.dart';
import 'package:inventory_system/features/sector/models/sector_model.dart';
import 'package:inventory_system/features/sector/ui/widgets/sector_actions.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:provider/provider.dart';

class SectorList extends StatefulWidget {
  const SectorList({Key? key}) : super(key: key);

  @override
  _SectorListState createState() => _SectorListState();
}

class _SectorListState extends State<SectorList> {
  late Future<List<Sector>> sectorsFuture;

  @override
  void initState() {
    super.initState();
    fetchSectorsWithCompanyId();
  }

  Future<void> fetchSectorsWithCompanyId() async {
    await withCompanyId(context, (companyId) async {
      final sectorDAO = Provider.of<SectorDAO>(context, listen: false);
      sectorsFuture = sectorDAO.fetchSectors(companyId);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Sector>>(
      future: sectorsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No sectors found.'));
        }

        List<Sector> sectors = snapshot.data!;
        return ListView.separated(
          itemCount: sectors.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final sector = sectors[index];
            return ListTile(
              title: Text('Sector: ${sector.name}'),
              subtitle: Text('Description: ${sector.description}'),
              trailing: SectorActions(sector: sector),
            );
          },
        );
      },
    );
  }

  // Additional methods as needed...
}
