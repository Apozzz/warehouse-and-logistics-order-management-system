import 'package:inventory_system/imports.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          centerTitle: true,
          backgroundColor: Colors.red.shade700,
        ),
        drawer: const NavigationWidget(mainWidget: 'product'),
        body: const ProductHomePage(title: 'Products Home Page'),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: const CustomTabBar(selectedIndex: -1),
        ),
      ),
    );
  }
}

class ProductHomePage extends StatefulWidget {
  const ProductHomePage({super.key, required this.title});
  final String title;

  @override
  State<ProductHomePage> createState() => ProductHomePageWidget();
}

class ProductHomePageWidget extends State<ProductHomePage> {
  var products = [];
  bool isLoading = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  String scannedBarcode = '';
  String scannedQrcode = '';
  String createdAt = '';
  var warehouseId = null;
  var warehouseList;
  Product product = Product(
    '',
    id: 0,
    name: '',
    description: '',
    qrcode: '',
    barcode: '',
    price: 0,
    quantity: 0,
    warehouseId: null,
  );

  var dbService = DataBaseService();
  var connection;
  var bodyList;

  Future<void> refreshProducts() async {
    products = await dbService.getRecords(connection, product);
    print(products);
    isLoading = false;
  }

  List<dynamic> getData() {
    return products;
  }

  void runScanner(ScanMode scanMode, BuildContext context) async {
    ScannerProvider scannerProvider = ScannerProvider(scanMode: scanMode);
    String scannedCode = await scannerProvider.scanCode();

    if (scannedCode == '-1') {
      return;
    }

    switch (scanMode) {
      case ScanMode.QR:
        scannedQrcode = scannedCode;
        print('SCANNED QR');
        print(scannedQrcode);
        break;
      case ScanMode.BARCODE:
        scannedBarcode = scannedCode;
        print('SCANNED BARCODE');
        print(scannedBarcode);
        break;
      default:
        break;
    }

    if (context.mounted) {
      Navigator.pop(context);
      scannerBuilder(context);
    }
  }

  void showForm(int? id, BuildContext context) async {
    var productId = 0;
    var scannerChild = const Text('Add Scan Code');

    if (id != null) {
      final productData = products.firstWhere((element) => element.id == id);

      productId = id;
      nameController.text = productData.name;
      descriptionController.text = productData.description;
      scannedBarcode = productData.barcode;
      scannedQrcode = productData.qrcode;
      priceController.text = productData.price.toString();
      quantityController.text = productData.quantity.toString();
      warehouseId = productData.warehouseId;
      createdAt = productData.createdAt;

      product = Product(
        createdAt,
        id: productId,
        name: nameController.text,
        description: descriptionController.text,
        barcode: scannedBarcode,
        qrcode: scannedQrcode,
        price: double.parse(priceController.text),
        quantity: int.parse(quantityController.text),
        warehouseId: warehouseId,
      );
    }

    if (products.isEmpty) {
      productId = await dbService.getHighestId(connection, product);
    }

    if (productId == 0 && products.isNotEmpty) {
      productId = id ?? products.last.id + 1;
    }

    if (context.mounted) {
      showModalBottomSheet(
          context: context,
          elevation: 5,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: 15,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                        hintText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Product Description',
                        hintText: 'Product Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Product Price',
                        hintText: 'Product Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Product Quantity',
                        hintText: 'Product Quantity',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 200,
                      child: SingleChildScrollView(
                        child: DropDownButton(
                          WarehouseProvider().getWarehouseInstance(),
                          warehouseId,
                          this,
                          'warehouseId',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 240,
                            height: 40,
                            child: ElevatedButton(
                              style: OutlinedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  side: BorderSide(
                                      color: Color(0x00000000),
                                      width: 0,
                                      style: BorderStyle.solid),
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                padding:
                                    const EdgeInsets.only(left: 6, right: 6),
                              ),
                              onPressed: () async {
                                if (nameController.text == '') {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      ErrorSnackBar().getErrorSnackBar(
                                        context,
                                        'Product must have Name',
                                      ),
                                    );
                                  }

                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }

                                  return;
                                }

                                warehouseId ??= product.warehouseId;

                                product = Product(
                                  createdAt.isEmpty
                                      ? const DateProvider()
                                          .getDateWithoutTime()
                                      : createdAt,
                                  id: productId,
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  barcode: scannedBarcode,
                                  qrcode: scannedQrcode,
                                  price: double.parse(
                                      priceController.text.isEmpty
                                          ? '0'
                                          : priceController.text),
                                  quantity: int.parse(
                                      quantityController.text.isEmpty
                                          ? '0'
                                          : quantityController.text),
                                  warehouseId: warehouseId,
                                );

                                // Save new journal
                                if (id == null) {
                                  await addProduct();
                                }

                                if (id != null) {
                                  await updateProduct();
                                }

                                // Close the bottom sheet
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                id == null
                                    ? 'Create New'.toUpperCase()
                                    : 'Update'.toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            width: 240,
                            height: 40,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  side: BorderSide(
                                      color: Color(0x00000000),
                                      width: 0,
                                      style: BorderStyle.solid),
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                padding:
                                    const EdgeInsets.only(left: 6, right: 6),
                              ),
                              onPressed: () async {
                                scannerBuilder(context);
                              },
                              child: Text(
                                'Add Scan Code'.toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  void cleanInputs() {
    nameController.text = '';
    descriptionController.text = '';
    scannedBarcode = '';
    scannedQrcode = '';
    priceController.text = '';
    quantityController.text = '';
    warehouseId = null;
  }

  void afterAction() async {
    cleanInputs();
    await refreshProducts();
    setNewState();
  }

  void setNewState() {
    setState(() {
      this;
    });
  }

  void setNewDropDownButtonValue(int? selectedWarehouseId, String columnName) {
    if (selectedWarehouseId == null) {
      return;
    }

    var productData = product.toMap();
    productData[columnName] = selectedWarehouseId;
    product = product.createModel(productData);
    warehouseId = selectedWarehouseId;
  }

  Future<void> addProduct() async {
    await dbService.insertRecord(connection, product);
    afterAction();
  }

  Future<void> updateProduct() async {
    await dbService.updateRecord(connection, product);
    afterAction();
  }

  Future<void> deleteProduct(context) async {
    if (await ProductProvider().checkProductUsedInOrders(product, [])) {
      ScaffoldMessenger.of(context).showSnackBar(
        ErrorSnackBar().getErrorSnackBar(
          context,
          'Product is used in Orders!',
        ),
      );

      return;
    }

    await dbService.deleteRecord(connection, product);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully deleted a product: ${product.name}!'),
    ));
    afterAction();
  }

  void deleteSelected(List<int> selectedIds, context) async {
    if (await ProductProvider()
        .checkProductUsedInOrders(product, selectedIds)) {
      ScaffoldMessenger.of(context).showSnackBar(
        ErrorSnackBar().getErrorSnackBar(
          context,
          'One or More Products are used in Orders!',
        ),
      );

      return;
    }

    await dbService.deleteSelected(connection, product, selectedIds);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully deleted ${selectedIds.length} products!'),
    ));
    afterAction();
  }

  Future<String> getDbConnection() async {
    connection ??= await dbService.getDatabaseConnection(product);
    await refreshProducts();

    return '';
  }

  Future<void> scannerBuilder(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: 120,
            ),
            child: SizedBox(
              height: 200,
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Choose Scanner Type',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 240,
                          height: 40,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                side: BorderSide(
                                    color: Color(0x00000000),
                                    width: 0,
                                    style: BorderStyle.solid),
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.only(left: 6, right: 6),
                            ),
                            onPressed: () async {
                              runScanner(ScanMode.QR, context);
                            },
                            child: Text(
                              'QR Code'.toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 35,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 240,
                          height: 40,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                side: BorderSide(
                                    color: Color(0x00000000),
                                    width: 0,
                                    style: BorderStyle.solid),
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.only(left: 6, right: 6),
                            ),
                            onPressed: () async {
                              runScanner(ScanMode.BARCODE, context);
                            },
                            child: Text(
                              'Barcode'.toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              scannedQrcode.isNotEmpty
                                  ? Icons.check
                                  : Icons.close_outlined,
                              color: scannedQrcode.isNotEmpty
                                  ? Colors.green
                                  : Colors.red),
                          Text(
                            'QR Code scan status',
                            style: TextStyle(
                                color: scannedQrcode.isNotEmpty
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              scannedBarcode.isNotEmpty
                                  ? Icons.check
                                  : Icons.close_outlined,
                              color: scannedBarcode.isNotEmpty
                                  ? Colors.green
                                  : Colors.red),
                          Text(
                            'Barcode scan status',
                            style: TextStyle(
                                color: scannedBarcode.isNotEmpty
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget bodyBuilder(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicatorWithText('Loading Product Data'),
          )
        : products.isNotEmpty
            ? CustomDataTable(ProductProvider(), this)
            : Center(
                child: Text(
                'There are no products at the moment!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getDbConnection(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          bodyList = bodyBuilder(context);
          return Scaffold(
            body: bodyList,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              child: const Icon(
                Icons.add,
                size: 30,
              ),
              onPressed: () => showForm(null, context),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicatorWithText('Connecting To Database'),
          );
        }
      },
    );
  }
}
