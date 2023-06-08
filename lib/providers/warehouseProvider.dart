import 'package:inventory_system/imports.dart';

class WarehouseProvider {
  Warehouse warehouse = Warehouse(
    '',
    id: 0,
    code: '',
    name: '',
    address: '',
  );

  WarehouseProvider();

  Future<Database> getDatabaseConnection(DataBaseService dbService) async {
    return await dbService.getDatabaseConnection(warehouse);
  }

  Warehouse getWarehouseInstance() {
    return warehouse;
  }

  Future<int> getCount() async {
    var dbService = DataBaseService();
    var connection = await dbService.getDatabaseConnection(warehouse);
    var records = await dbService.getRecords(connection, warehouse);

    return records.length;
  }

  Future<List<Object>> getRecords() async {
    var dbService = DataBaseService();
    var connection = await dbService.getDatabaseConnection(warehouse);

    return await dbService.getRecords(connection, warehouse);
  }

  Future<bool> checkWarehouseUsedInProducts(
      Warehouse warehouse, List<int> warehousesIdsList) async {
    var dbService = DataBaseService();
    var connection = await dbService.getDatabaseConnection(warehouse);
    var products = await dbService.getRecords(
        connection, ProductProvider().getProductInstance());
    var castedProducts = products.cast<Product>();
    var productWarehouseIds = castedProducts
        .map(
          (e) => e.warehouseId,
        )
        .toList();

    if (warehousesIdsList.isNotEmpty) {
      warehousesIdsList
          .removeWhere((element) => !productWarehouseIds.contains(element));

      return warehousesIdsList.isEmpty ? false : true;
    }

    return productWarehouseIds.contains(warehouse.id) ? true : false;
  }

  Map<double, double> getLineChartCoordinates(List<Object> records) {
    var castedRecords = records.cast<Warehouse>();
    final Map coordinates = {};
    List<String> dates = castedRecords.map((e) => e.createdAt).toList();
    List<String> distinctDates = dates.toSet().toList();
    distinctDates.sort();

    for (var date in dates) {
      double indexOfDate = distinctDates.indexOf(date).toDouble();

      coordinates.containsKey(indexOfDate)
          ? coordinates[indexOfDate]++
          : coordinates[indexOfDate] = 1.0;
    }

    return coordinates.cast<double, double>();
  }

  Widget getBottomSideTitles(
      List<Object> records, double value, TitleMeta meta) {
    var castedRecords = records.cast<Warehouse>();
    List<String> sortedDates = castedRecords.map((e) => e.createdAt).toList();
    sortedDates = sortedDates.toSet().toList();
    sortedDates.sort();

    return SideTitleWidget(
      space: 9,
      axisSide: meta.axisSide,
      child: Text(sortedDates.elementAtOrNull(value.toInt()) ?? ''),
    );
  }

  double getCoordinatesMaxYByDate(List<double> coordinates) {
    coordinates.sort();

    return coordinates.last;
  }

  double getCoordinatesMinYByDate(List<double> coordinates) {
    coordinates.sort();

    return coordinates.first;
  }

  Widget getWarehouseInfoColumn(Warehouse? warehouse, BuildContext context) {
    if (warehouse == null || warehouse.toMap().isEmpty) {
      return const Text('Warehouse was not found');
    }

    return Column(
      children: [
        Text(warehouse.code),
        Text(warehouse.name),
        Text(warehouse.address),
      ],
    );
  }

  Future<String> getWarehouseCodeById(
      DataBaseService dbService, Database connection, int? warehouseId) async {
    var warehouseRecord =
        await dbService.getRecord(connection, warehouse, warehouseId);

    if (warehouseRecord['id'] == null) {
      return '';
    }

    return warehouse.createModel(warehouseRecord).code;
  }

  List<Text> getTableColumnsNames() {
    return [
      const Text(''),
      const Text('ID'),
      const Text('Code'),
      const Text('Name'),
      const Text('Address'),
    ];
  }

  List<String> getColumns() {
    return [
      'id',
      'code',
      'name',
      'address',
    ];
  }

  List<DataCell> getDataCellList(
    Warehouse data,
    BuildContext context,
    WarehouseHomePageWidget warehousePage,
  ) {
    return [
      DataCell(
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  warehousePage.showForm(data.id, context);
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      right: 8, left: 4, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.edit),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        ' Edit ',
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
              ),
            ),
            PopupMenuItem(
              value: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Alert(
                    type: AlertType.warning,
                    context: context,
                    title: 'Are you sure?',
                    desc: 'This action will permanently delete this data',
                    buttons: [
                      DialogButton(
                        width: 240,
                        color: Colors.black,
                        onPressed: () => {},
                        child: SizedBox(
                          width: 240,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text(
                              'Cancel'.toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      DialogButton(
                        width: 240,
                        color: Colors.black,
                        onPressed: () {},
                        child: SizedBox(
                          width: 240,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              warehousePage.warehouse = data;
                              warehousePage.deleteWarehouse(context);
                              Navigator.pop(context, true);
                            },
                            child: Text(
                              'Delete'.toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).show();
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      right: 8, left: 7, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.delete),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Delete',
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert_outlined),
        ),
      ),
      DataCell(Text(data.id.toString())),
      DataCell(Text(data.code)),
      DataCell(Text(data.name)),
      DataCell(Text(data.address)),
    ];
  }
}
