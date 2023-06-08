import 'package:inventory_system/imports.dart';

class ProductProvider {
  Product product = Product(
    '',
    id: 0,
    name: '',
    description: '',
    qrcode: '',
    barcode: '',
    quantity: 0,
    price: 0,
  );

  ProductProvider();

  Future<void> getScannedProductInfo(
    String scannedText,
    DataBaseService dbService,
    Database connection,
    BuildContext context,
    String scanType,
  ) async {
    var result = await dbService.getRawQueryResults(
        connection,
        product.getProductByScanQuery(
          scannedText,
          scanType,
        ));

    connection = await WarehouseProvider().getDatabaseConnection(dbService);

    print(result.isEmpty);
    print(result);

    var singleProduct = result.isNotEmpty ? result[0] : null;
    Product? scannedProduct;

    if (singleProduct != null) {
      scannedProduct = product.createModel(singleProduct);
    }

    var products = await dbService.getRecords(connection, product);
    var castedProducts = products.cast<Product>();
    List<Product> productCopies = castedProducts
        .where((element) =>
            element.name == scannedProduct!.name &&
            element.description == scannedProduct.description &&
            element.price == scannedProduct.price &&
            element.barcode == scannedProduct.barcode &&
            element.qrcode == scannedProduct.qrcode)
        .toList();

    var warehouses = await dbService.getRecords(
        connection, WarehouseProvider().getWarehouseInstance());
    List<Warehouse> castedWarehouses = warehouses.cast<Warehouse>();
    List<Warehouse> filteredWarehouses = [];

    for (Product product in productCopies) {
      var warehouse = castedWarehouses
          .where((element) => element.id == product.warehouseId);

      if (warehouse.isEmpty) {
        continue;
      }

      filteredWarehouses.add(warehouse.first);
    }

    var textTheme = Theme.of(context).textTheme;

    if (context.mounted) {
      Alert(
        context: context,
        content: SizedBox(
          width: 600,
          height: 400,
          child: Column(
            children: [
              getProductInfoColumn(scannedProduct!, context),
              getWarehousesInfoColumn(
                  filteredWarehouses, productCopies, context),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            width: 240,
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
            child: SizedBox(
              width: 240,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'close'.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ).show();
    }
  }

  Future<Database> getDatabaseConnection(DataBaseService dbService) async {
    return await dbService.getDatabaseConnection(product);
  }

  Product getProductInstance() {
    return product;
  }

  Future<int> getCount() async {
    var dbService = DataBaseService();
    var connection = await dbService.getDatabaseConnection(product);
    var records = await dbService.getRecords(connection, product);

    return records.length;
  }

  Future<bool> checkProductUsedInOrders(
      Product product, List<int> productIdsList) async {
    var dbService = DataBaseService();
    var connection = await dbService.getDatabaseConnection(product);
    var deliveries = await dbService.getRecords(
        connection, OrderProvider().getOrderInstance());
    var castedOrders = deliveries.cast<Order>();
    var serializedProductIds = castedOrders
        .map(
          (e) => e.serializedProductIds,
        )
        .toList();
    List<String> productIds = [];

    for (var ids in serializedProductIds) {
      if (ids == null) {
        continue;
      }

      productIds += ProductSerializer().unserializeProductIds(ids);
    }

    if (productIdsList.isNotEmpty) {
      productIdsList
          .removeWhere((element) => !productIds.contains(element.toString()));

      return productIdsList.isEmpty ? false : true;
    }

    return productIds.contains(product.id.toString()) ? true : false;
  }

  Future<Map<int, String>> getProductsWarehouseCodesList(
      List<Product> products) async {
    var dbService = DataBaseService();
    var connection = await getDatabaseConnection(dbService);
    Map<int, String> warehouseNames = {};

    for (Product product in products) {
      var warehouseId = product.warehouseId;

      if (warehouseId == null) {
        continue;
      }

      warehouseNames[warehouseId] =
          await WarehouseProvider().getWarehouseCodeById(
        dbService,
        connection,
        warehouseId,
      );
    }

    return warehouseNames;
  }

  Future<List<Object>> getRecords() async {
    var dbService = DataBaseService();
    var connection = await dbService.getDatabaseConnection(product);

    return await dbService.getRecords(connection, product);
  }

  Map<double, double> getLineChartCoordinates(List<Object> records) {
    var castedRecords = records.cast<Product>();
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
    var castedRecords = records.cast<Product>();
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

  Widget getWarehousesInfoColumn(List<Warehouse> filteredWarehouses,
      List<Product> productCopies, BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    if (filteredWarehouses.isEmpty) {
      return Flexible(
        child: Column(children: [
          Text('Warehouses', style: textTheme.headline3),
          Text('There are no Warehouses Assigned', style: textTheme.bodyLarge)
        ]),
      );
    }

    return Flexible(
      child: Column(
        children: [
          Text('Warehouses', style: textTheme.headline3),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredWarehouses.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      top: 10,
                      bottom: 10,
                    ),
                    child: SizedBox(
                      width: 200,
                      height: 120,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber.shade50,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                'Code: ${filteredWarehouses[index].code}',
                                style: textTheme.headline6,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'Name: ${filteredWarehouses[index].name}',
                                style: textTheme.bodyLarge,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'Address: ${filteredWarehouses[index].address}',
                                style: textTheme.bodyLarge,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'Product Quantity: ${productCopies.where((element) => element.warehouseId == filteredWarehouses[index].id).first.quantity}',
                                style: textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget getProductInfoColumn(Product productData, BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    if (productData.toMap().isEmpty) {
      return Flexible(
        child: Column(children: [
          Text('Product', style: textTheme.headline3),
          Text('Product was not found', style: textTheme.bodyLarge)
        ]),
      );
    }

    return Flexible(
      child: Column(
        children: [
          Text('Product', style: textTheme.headline3),
          SizedBox(
            height: 100,
            child: Column(
              children: [
                Text(
                  'Name: ${productData.name}',
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyLarge,
                ),
                Text(
                  'Description: ${productData.description}',
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyLarge,
                ),
                Text(
                  'Price: ${const Text('\u{20AC}').data.toString()} ${productData.price.toString()}',
                  style: textTheme.bodyLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BarcodeImageDialog(
                            context: context,
                            barcode: Barcode.code128(),
                            barcodeData: productData.barcode,
                            buttonText: 'Barcode')
                        .getBarcodeImageDialog(),
                    BarcodeImageDialog(
                            context: context,
                            barcode: Barcode.qrCode(),
                            barcodeData: productData.qrcode,
                            buttonText: 'QR Code')
                        .getBarcodeImageDialog(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Text> getTableColumnsNames() {
    return [
      const Text(''),
      const Text('ID'),
      const Text('Name'),
      const Text('Description'),
      const Text('Barcode'),
      const Text('QRCode'),
      const Text('Quantity'),
      const Text('Price'),
      const Text('Warehouse'),
    ];
  }

  List<String> getColumns() {
    return [
      'id',
      'name',
      'description',
      'barcode',
      'qrcode',
      'quantity',
      'price',
      'warehouseId',
    ];
  }

  List<DataCell> getDataCellList(
    Product data,
    BuildContext context,
    ProductHomePageWidget productPage,
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
                  productPage.showForm(data.id, context);
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
                              productPage.product = data;
                              productPage.deleteProduct(context);
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
      DataCell(Text(data.name)),
      DataCell(Text(data.description)),
      DataCell(
        BarcodeImageDialog(
          context: context,
          barcode: Barcode.code128(),
          barcodeData: data.barcode,
          buttonText: 'Barcode',
        ).getBarcodeImageDialog(),
      ),
      DataCell(
        BarcodeImageDialog(
          context: context,
          barcode: Barcode.qrCode(),
          barcodeData: data.qrcode,
          buttonText: 'QR Code',
        ).getBarcodeImageDialog(),
      ),
      DataCell(Text(data.quantity.toString())),
      DataCell(Text(data.price.toString())),
      DataCell(Text(data.warehouseId.toString())),
    ];
  }
}
