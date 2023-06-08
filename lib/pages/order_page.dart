import 'package:inventory_system/imports.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        drawer: const NavigationWidget(mainWidget: 'order'),
        body: const OrderHomePage(title: 'Orders Home Page'),
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

class OrderHomePage extends StatefulWidget {
  const OrderHomePage({super.key, required this.title});
  final String title;

  @override
  State<OrderHomePage> createState() => OrderHomePageWidget();
}

class OrderHomePageWidget extends State<OrderHomePage> {
  var orders = [];
  bool isLoading = true;
  bool loadingPdf = false;
  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? serializedProductsIds = null;
  String? serializedProductsQuantities = null;
  String createdAt = '';
  Order order = Order(
    '',
    id: 0,
    code: '',
    name: '',
    surname: '',
    phone: '',
    serializedProductIds: null,
    serializedProductQuantities: null,
  );
  var dbService = DataBaseService();
  var connection;
  var bodyList;

  Future<void> refreshOrders() async {
    orders = await dbService.getRecords(connection, order);
    isLoading = false;
  }

  List<dynamic> getData() {
    return orders;
  }

  void afterAction() async {
    cleanInputs();
    await refreshOrders();
    setNewState();
  }

  void setNewMultiselectDropDownButtonValue(List<String> selectedProductsIds,
      List<String> selectedProductsQuantities) {
    var serializedSelectedProductIds = null;
    var serializedSelectedProductQuantities = null;

    if (selectedProductsIds.isNotEmpty) {
      serializedSelectedProductIds =
          ProductSerializer().serializeProductIds(selectedProductsIds);
    }

    if (selectedProductsQuantities.isNotEmpty) {
      serializedSelectedProductQuantities =
          ProductSerializer().serializeProductIds(selectedProductsQuantities);
    }

    var orderData = order.toMap();
    orderData['serializedProductIds'] = serializedSelectedProductIds;
    orderData['serializedProductQuantities'] =
        serializedSelectedProductQuantities;
    order = order.createModel(orderData);
    serializedProductsIds = serializedSelectedProductIds;
    serializedProductsQuantities = serializedSelectedProductQuantities;
  }

  void showForm(int? id, BuildContext context) async {
    var orderId = 0;
    serializedProductsIds = null;
    serializedProductsQuantities = null;

    if (id != null) {
      final orderData = orders.firstWhere((element) => element.id == id);

      orderId = id;
      codeController.text = orderData.code;
      nameController.text = orderData.name;
      surnameController.text = orderData.surname;
      phoneController.text = orderData.phone;
      serializedProductsIds = orderData.serializedProductIds;
      serializedProductsQuantities = orderData.serializedProductQuantities;
      createdAt = orderData.createdAt;

      order = Order(
        createdAt,
        id: orderId,
        code: codeController.text,
        name: nameController.text,
        surname: surnameController.text,
        phone: phoneController.text,
        serializedProductIds: serializedProductsIds,
        serializedProductQuantities: serializedProductsQuantities,
      );
    }

    if (orders.isEmpty) {
      orderId = await dbService.getHighestId(connection, order);
    }

    if (orderId == 0 && orders.isNotEmpty) {
      orderId = id ?? orders.last.id + 1;
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
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
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
                      controller: codeController,
                      decoration: const InputDecoration(
                        labelText: 'Order Code',
                        hintText: 'Order Code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Customer Name',
                        hintText: 'Customer Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: surnameController,
                      decoration: const InputDecoration(
                        labelText: 'Customer Surname',
                        hintText: 'Customer Surname',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Customer Phone',
                        hintText: 'Customer Phone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 200,
                      child: SingleChildScrollView(
                        child: MultiselectDropDownButton(
                          ProductProvider().getProductInstance(),
                          serializedProductsIds != null
                              ? ProductSerializer()
                                  .unserializeProductIds(serializedProductsIds!)
                              : null,
                          serializedProductsQuantities != null
                              ? ProductSerializer().unserializeProductIds(
                                  serializedProductsQuantities!)
                              : null,
                          this,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                                if (serializedProductsIds == null ||
                                    order.serializedProductIds == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    ErrorSnackBar().getErrorSnackBar(
                                      context,
                                      'Product is required!',
                                    ),
                                  );

                                  return;
                                }

                                order = Order(
                                  createdAt.isEmpty
                                      ? const DateProvider()
                                          .getDateWithoutTime()
                                      : createdAt,
                                  id: orderId,
                                  code: codeController.text,
                                  name: nameController.text,
                                  surname: surnameController.text,
                                  phone: phoneController.text,
                                  serializedProductIds: serializedProductsIds,
                                  serializedProductQuantities:
                                      serializedProductsQuantities,
                                );
                                print('PRIES SAVE');
                                print(order);

                                // Save new journal
                                if (id == null) {
                                  await addOrder();
                                }

                                if (id != null) {
                                  await updateOrder();
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
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void cleanInputs() {
    codeController.text = '';
    nameController.text = '';
    surnameController.text = '';
    phoneController.text = '';
    serializedProductsIds = null;
    serializedProductsQuantities = null;
  }

  void setNewState() {
    setState(() {
      this;
    });
  }

  Future<void> addOrder() async {
    await dbService.insertRecord(connection, order);
    afterAction();
  }

  Future<void> updateOrder() async {
    await dbService.updateRecord(connection, order);
    afterAction();
  }

  Future<void> deleteOrder(context) async {
    if (await OrderProvider().checkOrderUsedInDeliveries(order, [])) {
      ScaffoldMessenger.of(context).showSnackBar(
        ErrorSnackBar().getErrorSnackBar(
          context,
          'Order is used in Deliveries!',
        ),
      );

      return;
    }

    await dbService.deleteRecord(connection, order);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully deleted an order with code: ${order.code} !'),
    ));
    afterAction();
  }

  void deleteSelected(List<int> selectedIds, context) async {
    if (await OrderProvider().checkOrderUsedInDeliveries(order, selectedIds)) {
      ScaffoldMessenger.of(context).showSnackBar(
        ErrorSnackBar().getErrorSnackBar(
          context,
          'One or More Orders are used in Deliveries!',
        ),
      );

      return;
    }

    await dbService.deleteSelected(connection, order, selectedIds);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully deleted ${selectedIds.length} orders!'),
    ));
    afterAction();
  }

  Future<String> getDbConnection() async {
    connection ??= await dbService.getDatabaseConnection(order);

    print(connection);
    await refreshOrders();

    return '';
  }

  Widget bodyBuilder(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicatorWithText('Loading Order Data'),
          )
        : orders.isNotEmpty
            ? CustomDataTable(OrderProvider(), this)
            : Center(
                child: Text(
                'There are no orders at the moment!',
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
