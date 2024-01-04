import 'package:flutter/material.dart';
import 'package:inventory_system/enums/delivery_status.dart';
import 'package:inventory_system/enums/package_progress_status.dart';
import 'package:inventory_system/features/delivery/DAOs/delivery_dao.dart';
import 'package:inventory_system/features/packages/services/packaging_service.dart';
import 'package:inventory_system/features/packages/ui/widgets/package_progress_item.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:inventory_system/utils/barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:inventory_system/features/packages/DAOs/package_progress_dao.dart';
import 'package:inventory_system/features/packages/models/package_progress.dart';

class PackageProgressPage extends StatefulWidget {
  final String deliveryId;

  const PackageProgressPage({Key? key, required this.deliveryId})
      : super(key: key);

  @override
  _PackageProgressPageState createState() => _PackageProgressPageState();
}

class _PackageProgressPageState extends State<PackageProgressPage> {
  late Future<List<PackageProgress>> futurePackageProgressList;
  late DeliveryDAO deliveryDAO;
  bool isFinished = false;
  DeliveryStatus deliveryStatus = DeliveryStatus.NotStarted;

  @override
  void initState() {
    super.initState();
    futurePackageProgressList = _fetchPackageProgress();
    deliveryDAO = Provider.of<DeliveryDAO>(context, listen: false);
  }

  Future<void> _updateIsFinished(
      List<PackageProgress> packageProgressList) async {
    final delivery = await deliveryDAO.getDeliveryById(widget.deliveryId);

    bool allPackagesPackaged = packageProgressList
        .every((p) => p.status == PackageProgressStatus.Packaged);
    bool deliveryIsInValidState =
        delivery.status == DeliveryStatus.NotStarted ||
            delivery.status == DeliveryStatus.Preparing;
    print(deliveryIsInValidState);

    setState(() {
      deliveryStatus = delivery.status;
      isFinished = allPackagesPackaged && deliveryIsInValidState;
    });
  }

  Future<List<PackageProgress>> _fetchPackageProgress() async {
    final packageProgressDAO =
        Provider.of<PackageProgressDAO>(context, listen: false);
    final packageProgressList = await packageProgressDAO
        .getPackageProgressByDeliveryId(widget.deliveryId);

    await _updateIsFinished(packageProgressList);

    return Future.value(packageProgressList);
  }

  Future<void> _scanAndProcessPackage() async {
    final barcode = await BarcodeScanner.scanBarcode(context);
    if (barcode == null) {
      return;
    }

    final packagingService =
        Provider.of<PackagingService>(context, listen: false);
    await packagingService.scanAndProcessPackage(widget.deliveryId, barcode);

    // Reload the package progress list to reflect changes
    setState(() {
      futurePackageProgressList = _fetchPackageProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    final deliveryId = widget.deliveryId;

    return BaseScaffold(
      appBar: AppBar(
        title: Text('Package Progress for Delivery $deliveryId'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Package Progress for Delivery: $deliveryId\nCurrent Status: ${deliveryStatus.name.toString()}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PackageProgress>>(
              future: futurePackageProgressList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No package progress found.'));
                }

                List<PackageProgress> packageProgressList = snapshot.data!;

                return ListView.builder(
                  itemCount: packageProgressList.length,
                  itemBuilder: (context, index) {
                    return PackageProgressItem(
                        progress: packageProgressList[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _finishedButton(),
          const SizedBox(width: 8), // Spacing between buttons
          _scanButton(),
        ],
      ),
    );
  }

  Widget _finishedButton() {
    return FloatingActionButton(
      heroTag: 'finishedButton',
      onPressed: () async {
        final deliveryDAO = Provider.of<DeliveryDAO>(context, listen: false);

        if (!isFinished) {
          return;
        }

        await deliveryDAO.updateDelivery(
            widget.deliveryId, {'status': DeliveryStatus.InTransit.index});

        setState(() {
          deliveryStatus = DeliveryStatus.InTransit;
          isFinished = false;
        });
      },
      backgroundColor: isFinished ? Colors.green : Colors.grey,
      child: const Icon(Icons.check),
    );
  }

  Widget _scanButton() {
    return FloatingActionButton(
      heroTag: 'scanButton',
      onPressed: () => _scanAndProcessPackage(),
      child: const Icon(Icons.camera_alt),
    );
  }
}
