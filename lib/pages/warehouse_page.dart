import 'package:inventory_system/imports.dart';

class WarehousePage extends StatelessWidget {
  const WarehousePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Warehouse'),
          centerTitle: true,
          backgroundColor: Colors.blue.shade700,
        ),
        drawer: const NavigationWidget(mainWidget: 'warehouse'),
        body: const WarehouseHomePage(title: 'Warehouses Home Page'),
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

class WarehouseHomePage extends StatefulWidget {
  const WarehouseHomePage({super.key, required this.title});
  final String title;

  @override
  State<WarehouseHomePage> createState() => WarehouseHomePageWidget();
}

class WarehouseHomePageWidget extends State<WarehouseHomePage> {
  var warehouses = [];
  bool isLoading = true;
  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  Warehouse warehouse = Warehouse('', id: 0, code: '', name: '', address: '');
  var dbService = DataBaseService();
  var connection;
  var bodyList;
  String createdAt = '';

  Future<void> refreshWarehouses() async {
    warehouses = await dbService.getRecords(connection, warehouse);
    print(warehouses);
    print("REFRESH WAREHOUSES");
    isLoading = false;
  }

  List<dynamic> getData() {
    return warehouses;
  }

  void showForm(int? id, BuildContext context) async {
    var warehouseId = 0;

    if (id != null) {
      final warehouseData =
          warehouses.firstWhere((element) => element.id == id);

      warehouseId = id;
      codeController.text = warehouseData.code;
      nameController.text = warehouseData.name;
      addressController.text = warehouseData.address;
      createdAt = warehouseData.createdAt;

      warehouse = Warehouse(
        createdAt,
        id: warehouseId,
        code: codeController.text,
        name: nameController.text,
        address: addressController.text,
      );
    }

    if (warehouses.isEmpty) {
      warehouseId = await dbService.getHighestId(connection, warehouse);
    }

    if (warehouseId == 0 && warehouses.isNotEmpty) {
      warehouseId = id ?? warehouses.last.id + 1;
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
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      labelText: 'Warehouse Code',
                      hintText: 'Warehouse Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'Warehouse Name',
                      hintText: 'Warehouse Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: addressController,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                      labelText: 'Warehouse Address',
                      hintText: 'Warehouse Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                              if (codeController.text == '') {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    ErrorSnackBar().getErrorSnackBar(
                                      context,
                                      'Warehouse must have Code',
                                    ),
                                  );
                                }

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }

                                return;
                              }

                              if (addressController.text == '') {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    ErrorSnackBar().getErrorSnackBar(
                                      context,
                                      'Warehouse must have Address',
                                    ),
                                  );
                                }

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }

                                return;
                              }

                              warehouse = Warehouse(
                                createdAt.isEmpty
                                    ? const DateProvider().getDateWithoutTime()
                                    : createdAt,
                                id: warehouseId,
                                code: codeController.text,
                                name: nameController.text,
                                address: addressController.text,
                              );

                              // Save new journal
                              if (id == null) {
                                await addWarehouse();
                              }

                              if (id != null) {
                                await updateWarehouse();
                              }

                              // Close the bottom sheet
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              id == null
                                  ? 'Create New'.toUpperCase()
                                  : 'Update'.toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
    }
  }

  void cleanInputs() {
    codeController.text = '';
    nameController.text = '';
    addressController.text = '';
  }

  void setNewState() {
    setState(() {
      this;
    });
  }

  void afterAction() async {
    cleanInputs();
    await refreshWarehouses();
    setNewState();
  }

  Future<void> addWarehouse() async {
    await dbService.insertRecord(connection, warehouse);
    afterAction();
  }

  Future<void> updateWarehouse() async {
    await dbService.updateRecord(connection, warehouse);
    afterAction();
  }

  void deleteWarehouse(context) async {
    if (await WarehouseProvider().checkWarehouseUsedInProducts(warehouse, [])) {
      ScaffoldMessenger.of(context).showSnackBar(
        ErrorSnackBar().getErrorSnackBar(
          context,
          'Warehouse is used in Products!',
        ),
      );

      return;
    }

    await dbService.deleteRecord(connection, warehouse);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          'Successfully deleted a warehouse with code: ${warehouse.code} !'),
    ));
    afterAction();
  }

  void deleteSelected(List<int> selectedIds, context) async {
    if (await WarehouseProvider()
        .checkWarehouseUsedInProducts(warehouse, selectedIds)) {
      ScaffoldMessenger.of(context).showSnackBar(
        ErrorSnackBar().getErrorSnackBar(
          context,
          'One or More Warehouses are used in Products!',
        ),
      );

      return;
    }

    await dbService.deleteSelected(connection, warehouse, selectedIds);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully deleted ${selectedIds.length} products!'),
    ));
    afterAction();
  }

  Future<String> getDbConnection() async {
    connection ??= await dbService.getDatabaseConnection(warehouse);

    print(connection);
    await refreshWarehouses();

    return '';
  }

  Widget bodyBuilder(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicatorWithText('Loading Warehouse Data'),
          )
        : warehouses.isNotEmpty
            ? CustomDataTable(WarehouseProvider(), this)
            : Center(
                child: Text(
                'There are no warehouses at the moment!',
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
          print(bodyList);
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
