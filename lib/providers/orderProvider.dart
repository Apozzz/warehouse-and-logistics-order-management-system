import 'package:inventory_system/imports.dart';

class OrderProvider {
  Order order = Order(
    '',
    id: 0,
    code: '',
    name: '',
    surname: '',
    phone: '',
    serializedProductIds: '',
    serializedProductQuantities: '',
  );

  OrderProvider();

  Order getOrderInstance() {
    return order;
  }

  Future<int> getCount() async {
    var dbService = DataBaseService();
    var connection = await dbService.getDatabaseConnection(order);
    var records = await dbService.getRecords(connection, order);

    return records.length;
  }

  Future<List<Object>> getRecords() async {
    var dbService = DataBaseService();
    var connection = await dbService.getDatabaseConnection(order);

    return await dbService.getRecords(connection, order);
  }

  Future<bool> checkOrderUsedInDeliveries(
      Order order, List<int> orderIdsList) async {
    var dbService = DataBaseService();
    var connection = await dbService.getDatabaseConnection(order);
    var deliveries = await dbService.getRecords(
        connection, DeliveryProvider().getInstance());
    var castedDeliveries = deliveries.cast<Delivery>();
    var orderIds = castedDeliveries.map((e) => e.deliveryOrderId).toList();

    if (orderIdsList.isNotEmpty) {
      orderIdsList.removeWhere((element) => !orderIds.contains(element));

      return orderIdsList.isEmpty ? false : true;
    }

    return orderIds.contains(order.id) ? true : false;
  }

  Map<double, double> getLineChartCoordinates(List<Object> records) {
    var castedRecords = records.cast<Order>();
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
    var castedRecords = records.cast<Order>();
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

  Future<Database> getDatabaseConnection(DataBaseService dbService) async {
    return await dbService.getDatabaseConnection(order);
  }

  Future<List<Product>> getProductsByOrderSerializedProductIds(
      DataBaseService dbService, String? serializedProductIds) async {
    var productInstance = ProductProvider().getProductInstance();
    var connection = await ProductProvider().getDatabaseConnection(dbService);
    var products = await dbService.getRecordsByIds(
        connection, productInstance, serializedProductIds);

    return products.isNotEmpty
        ? products.map<Product>((e) => productInstance.createModel(e)).toList()
        : [];
  }

  Future<List<String>> getProductTitlesByOrderSerializedProductIds(
      DataBaseService dbService, String? serializedProductIds) async {
    var productInstance = ProductProvider().getProductInstance();
    var products = [];

    if (serializedProductIds != null) {
      products = await getProductsByOrderSerializedProductIds(
          dbService, serializedProductIds);
    }

    return products.isNotEmpty
        ? products
            .map<String>((e) => productInstance.createModel(e.toMap()).name)
            .toList()
        : [];
  }

  Map<String, String> getIdQuantity(Order order) {
    Map<String, String> idQuantityMap = {};

    if (order.serializedProductIds == null ||
        order.serializedProductQuantities == null) {
      return idQuantityMap;
    }

    var unserializedOrderProductIds =
        ProductSerializer().unserializeProductIds(order.serializedProductIds!);
    var unserializedOrderProductQuantities = ProductSerializer()
        .unserializeProductIds(order.serializedProductQuantities!);

    for (var i = 0; i < unserializedOrderProductIds.length; i++) {
      idQuantityMap[unserializedOrderProductIds[i]] =
          unserializedOrderProductQuantities[i];
    }

    return idQuantityMap;
  }

  double getOrderTotalPriceByProductIds(
      List<Product> products, Map<String, String> idQuantity) {
    double totalPrice = 0;

    products.forEach((element) {
      totalPrice +=
          element.price * double.parse(idQuantity[element.id.toString()]!);
    });

    return totalPrice;
  }

  Future<void> downloadPdf(Order order, BuildContext context,
      OrderHomePageWidget orderWidget) async {
    var pdfProvider = PdfProvider(order: order);

    orderWidget.loadingPdf = true;
    orderWidget.setNewState();

    await pdfProvider.saveAsFile(
      context,
      (PdfPageFormat pdfPageFormat) => pdfProvider.buildPdf(pdfPageFormat),
      PdfPageFormat.a4,
    );

    orderWidget.loadingPdf = false;
    orderWidget.setNewState();
  }

  List<Text> getTableColumnsNames() {
    return [
      const Text(''),
      const Text('ID'),
      const Text('Code'),
      const Text('Name'),
      const Text('Surname'),
      const Text('Phone'),
      const Text('Serialized IDs'),
      const Text('Serialized QTYs'),
    ];
  }

  List<String> getColumns() {
    return [
      'id',
      'code',
      'name',
      'surname',
      'phone',
      'serializedProductIds',
      'serializedProductQuantities',
    ];
  }

  List<DataCell> getDataCellList(
    Order data,
    BuildContext context,
    OrderHomePageWidget orderPage,
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
                  downloadPdf(data, context, orderPage);
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      right: 8, left: 8, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.picture_as_pdf),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'PDF',
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
                  orderPage.showForm(data.id, context);
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      right: 8, left: 8, top: 4, bottom: 4),
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
              value: 2,
              child: GestureDetector(
                onTap: () async {
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
                              orderPage.order = data;
                              orderPage.deleteOrder(context);
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
                      right: 8, left: 8, top: 4, bottom: 4),
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
      DataCell(Text(data.surname)),
      DataCell(Text(data.phone)),
      DataCell(Text(data.serializedProductIds ?? '')),
      DataCell(Text(data.serializedProductQuantities ?? '')),
    ];
  }
}
