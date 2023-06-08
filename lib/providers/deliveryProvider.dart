import 'package:inventory_system/imports.dart';

class DeliveryProvider {
  Delivery delivery = Delivery(
    '',
    '',
    id: 0,
    code: '',
    name: '',
    surname: '',
    phone: '',
    courierIdentification: '',
    deliveryOrderId: -1,
    deliveryDate: '',
    deliveryTo: '',
    deliveryFrom: '',
    deliveryStatus: 0,
  );

  DeliveryProvider();

  Delivery getInstance() {
    return delivery;
  }

  Future<int> getCount() async {
    var dbService = DataBaseService();
    var connection = await dbService.getDatabaseConnection(delivery);
    var records = await dbService.getRecords(connection, delivery);

    return records.length;
  }

  Future<double> getGainsByDate(String date, List<Delivery> deliveries) async {
    double overAllAmount = 0.0;
    deliveries = deliveries.where((e) => e.updatedAt == date).toList();
    var dbService = DataBaseService();
    var connection = await dbService.getDatabaseConnection(delivery);
    var warehouses = await dbService.getRecords(
        connection, WarehouseProvider().getWarehouseInstance());
    var casteedWarehouses = warehouses.cast<Warehouse>();
    List<String> warehouseAdresses =
        casteedWarehouses.map((e) => e.address).toList();

    for (Delivery delivery in deliveries) {
      if (delivery.deliveryStatus != DeliveryStatus.DELIVERED.index) {
        continue;
      }

      if (!warehouseAdresses.contains(delivery.deliveryFrom) &&
          !warehouseAdresses.contains(delivery.deliveryTo)) {
        continue;
      }

      var orderData = await dbService.getRecord(connection,
          OrderProvider().getOrderInstance(), delivery.deliveryOrderId);
      Order order = OrderProvider().getOrderInstance().createModel(orderData);
      var products = await OrderProvider()
          .getProductsByOrderSerializedProductIds(
              dbService, order.serializedProductIds);
      Map<String, String> idQuantity = OrderProvider().getIdQuantity(order);

      switch (warehouseAdresses.contains(delivery.deliveryFrom)) {
        case true:
          overAllAmount += OrderProvider()
              .getOrderTotalPriceByProductIds(products, idQuantity);

          break;
        case false:
          overAllAmount -= OrderProvider()
              .getOrderTotalPriceByProductIds(products, idQuantity);
      }
    }

    return overAllAmount;
  }

  Future<List<Object>> getRecords() async {
    var dbService = DataBaseService();
    var connection = await dbService.getDatabaseConnection(delivery);

    return await dbService.getRecords(connection, delivery);
  }

  Future<Map<double, double>> getLineChartCoordinatesForGains(
      List<Object> records) async {
    var castedRecords = records.cast<Delivery>();
    final Map coordinates = {};
    List<String> dates = castedRecords.map((e) => e.createdAt).toList();
    List<String> distinctDates = dates.toSet().toList();
    distinctDates.sort();

    for (var date in dates) {
      double indexOfDate = distinctDates.indexOf(date).toDouble();

      coordinates.containsKey(indexOfDate)
          ? coordinates[indexOfDate] +=
              await getGainsByDate(date, castedRecords)
          : coordinates[indexOfDate] =
              await getGainsByDate(date, castedRecords);
    }

    return coordinates.cast<double, double>();
  }

  Map<double, double> getLineChartCoordinates(List<Object> records) {
    var castedRecords = records.cast<Delivery>();
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
    var castedRecords = records.cast<Delivery>();
    List<String> sortedDates = castedRecords.map((e) => e.updatedAt).toList();
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

  Future<Product?> findProductCopyWithGivenWarehouseId(Product product,
      int warehouseId, DataBaseService dbService, Database connection) async {
    var products = await dbService.getRecords(connection, product);
    var castedProducts = products.cast<Product>();
    var productCopy = castedProducts
        .where((element) =>
            element.warehouseId == warehouseId &&
            element.name == product.name &&
            element.description == product.description &&
            element.price == product.price &&
            element.barcode == product.barcode &&
            element.qrcode == product.qrcode)
        .toList();

    return productCopy.isEmpty ? null : productCopy.first;
  }

  Future<Widget> getDeliveryStatusPieChart(DataBaseService dbService) async {
    List<String> pieNames =
        DeliveryStatus.values.map<String>((e) => e.name).toList();
    var connection = await dbService.getDatabaseConnection(delivery);
    var deliveries = await dbService.getRecords(connection, delivery);

    if (deliveries.isEmpty) {
      return const SizedBox(width: 0, height: 0);
    }

    List<int> pieValues = List.generate(
      pieNames.length,
      (index) {
        return deliveries
            .cast<Delivery>()
            .where((e) => e.deliveryStatus == index)
            .length;
      },
    );

    return PieChartWidget(pieNames, pieValues);
  }

  bool addressesContainWarehouseAddress(
      Delivery delivery, List<Warehouse> warehouses) {
    for (var warehouse in warehouses) {
      var address = warehouse.address;

      if (delivery.deliveryFrom == address || delivery.deliveryTo == address) {
        return true;
      }
    }

    return false;
  }

  Map<int, String> getDeliveryStatusMapByCurrentStatus(int currentStatusId) {
    Map<int, String> deliveryStatuses = {};

    switch (currentStatusId) {
      case 0:
        deliveryStatuses[2] = DeliveryStatus.IN_PROGGRESS.name;
        break;
      case 1:
        deliveryStatuses[0] = DeliveryStatus.IDLE.name;
        break;
      case 2:
        deliveryStatuses[1] = DeliveryStatus.CANCELED.name;
        deliveryStatuses[3] = DeliveryStatus.DELIVERED.name;
        break;
    }

    return deliveryStatuses;
  }

  Future<String> checkDeliveryProductsQuantity(
    Delivery delivery,
    Database connection,
    DataBaseService dbService,
    List<Warehouse> warehouses,
  ) async {
    if (delivery.deliveryStatus != DeliveryStatus.IN_PROGGRESS.index) {
      return '';
    }

    var orderData = await dbService.getRecord(connection,
        OrderProvider().getOrderInstance(), delivery.deliveryOrderId);
    Order order = OrderProvider().getOrderInstance().createModel(orderData);
    Map<String, String> idQuantity = OrderProvider().getIdQuantity(order);
    List<Product> products =
        await OrderProvider().getProductsByOrderSerializedProductIds(
      dbService,
      order.serializedProductIds,
    );
    var warehousesAddresses = warehouses.map((e) => e.address).toList();

    for (Product product in products) {
      List<Warehouse> warehouseById = warehouses
          .where((warehouse) =>
              warehouse.id == product.warehouseId &&
              warehouse.address == delivery.deliveryFrom)
          .toList();

      if (!idQuantity.containsKey(product.id.toString())) {
        continue;
      }

      if (warehousesAddresses.contains(delivery.deliveryTo) &&
          !warehousesAddresses.contains(delivery.deliveryFrom)) {
        continue;
      }

      if (warehouseById.isEmpty) {
        return 'Products must be from Warehouse that they are delivered from';
      }

      if (product.quantity - int.parse(idQuantity[product.id.toString()]!) <
          0) {
        return 'Your Products Quantity is too low to deliver Order';
      }
    }

    return '';
  }

  Future<void> updateDeliveryProductsQuantity(
    Delivery delivery,
    Database connection,
    DataBaseService dbService,
    List<Warehouse> warehouses,
  ) async {
    var orderData = await dbService.getRecord(connection,
        OrderProvider().getOrderInstance(), delivery.deliveryOrderId);
    Order order = OrderProvider().getOrderInstance().createModel(orderData);
    Map<String, String> idQuantity = OrderProvider().getIdQuantity(order);
    List<Product> products =
        await OrderProvider().getProductsByOrderSerializedProductIds(
      dbService,
      order.serializedProductIds,
    );
    var warehousesAddresses = warehouses.map((e) => e.address).toList();

    for (Product product in products) {
      if (!idQuantity.containsKey(product.id.toString())) {
        continue;
      }

      var productData = product.toMap();
      int quantity = productData['quantity'];
      int orderProductQuantity = int.parse(idQuantity[product.id.toString()]!);
      Product newProduct = product.createModel(productData);
      List<Warehouse> warehouseById = warehouses
          .where((warehouse) =>
              warehouse.id == product.warehouseId &&
              warehouse.address == delivery.deliveryTo)
          .toList();

      List<Warehouse> deliveryToWarehouse = warehouses
          .where((warehouse) => warehouse.address == delivery.deliveryTo)
          .toList();

      if (warehousesAddresses.contains(delivery.deliveryTo)) {
        if (delivery.deliveryStatus == DeliveryStatus.DELIVERED.index) {
          if (warehouseById.isNotEmpty) {
            productData['quantity'] = quantity + orderProductQuantity;
            newProduct = product.createModel(productData);
            await dbService.updateRecord(connection, newProduct);
          } else {
            var productCopyWithWarehouseId = await ProductProvider()
                .findProductCopyWithGivenWarehouseId(product,
                    deliveryToWarehouse.first.id, dbService, connection);
            if (productCopyWithWarehouseId == null) {
              int highestId = await dbService.getHighestId(connection, product);
              productData['createdAt'] =
                  const DateProvider().getDateWithoutTime();
              productData['id'] = highestId + 1;
              productData['quantity'] = orderProductQuantity;
              productData['warehouseId'] = deliveryToWarehouse.first.id;
              newProduct = product.createModel(productData);
              await dbService.insertRecord(connection, newProduct);
            } else {
              productData['id'] = productCopyWithWarehouseId.id;
              productData['warehouseId'] =
                  productCopyWithWarehouseId.warehouseId;
              productData['quantity'] =
                  orderProductQuantity + productCopyWithWarehouseId.quantity;
              newProduct = product.createModel(productData);
              await dbService.updateRecord(connection, newProduct);
            }
          }
        }
      }

      if (warehousesAddresses.contains(delivery.deliveryFrom)) {
        if (delivery.deliveryStatus == DeliveryStatus.IDLE.index ||
            delivery.deliveryStatus == DeliveryStatus.DELIVERED.index) {
          continue;
        }

        if (delivery.deliveryStatus == DeliveryStatus.IN_PROGGRESS.index) {
          productData['quantity'] = quantity - orderProductQuantity;
          newProduct = product.createModel(productData);
        }

        if (delivery.deliveryStatus == DeliveryStatus.CANCELED.index) {
          productData['quantity'] = quantity + orderProductQuantity;
          newProduct = product.createModel(productData);
        }

        await dbService.updateRecord(connection, newProduct);
      }
    }
  }

  List<Text> getTableColumnsNames() {
    return [
      const Text(''),
      const Text('ID'),
      const Text('Code'),
      const Text('Name'),
      const Text('Surname'),
      const Text('Phone'),
      const Text('Courier ID'),
      const Text('Delivery Order ID'),
      const Text('Delivery Date'),
      const Text('Delivery Status'),
      const Text('Delivery Start Location'),
      const Text('Delivery Destination Location'),
    ];
  }

  List<String> getColumns() {
    return [
      'id',
      'code',
      'name',
      'surname',
      'phone',
      'courierIdentification',
      'deliveryOrderId',
      'deliveryDate',
      'deliveryStatus',
      'deliveryFrom',
      'deliveryTo',
    ];
  }

  List<DataCell> getDataCellList(
    Delivery data,
    BuildContext context,
    DeliveryHomePageWidget deliveryPage,
  ) {
    return [
      DataCell(
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 0,
              child: data.deliveryStatus == 3
                  ? GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.only(
                            right: 8, left: 8, top: 4, bottom: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 2, color: Colors.black),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.change_circle_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Change Unavailable',
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          ],
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        await deliveryPage.changeDeliveryStatusForm(
                          context,
                          data,
                        );
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
                            const Icon(Icons.change_circle_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Status',
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
                  deliveryPage.showForm(data.id, context);
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
                              deliveryPage.delivery = data;
                              deliveryPage.deleteDelivery(context);
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
      DataCell(Text(data.courierIdentification)),
      DataCell(Text(data.deliveryOrderId.toString())),
      DataCell(Text(data.deliveryDate)),
      DataCell(Text(DeliveryStatus.values[data.deliveryStatus].name)),
      DataCell(Text(data.deliveryFrom)),
      DataCell(Text(data.deliveryTo)),
    ];
  }
}
