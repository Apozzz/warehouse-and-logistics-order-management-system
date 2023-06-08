import 'package:inventory_system/imports.dart';

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Delivery'),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        drawer: const NavigationWidget(mainWidget: 'delivery'),
        body: const DeliveryHomePage(),
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

class DeliveryHomePage extends StatefulWidget {
  const DeliveryHomePage({super.key});

  @override
  State<DeliveryHomePage> createState() => DeliveryHomePageWidget();
}

class DeliveryHomePageWidget extends State<DeliveryHomePage> {
  var deliveries = [];
  bool isLoading = true;
  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  TextEditingController deliveryDateController = TextEditingController();
  final TextEditingController deliveryToController = TextEditingController();
  final TextEditingController deliveryFromController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController courierIdentificationController =
      TextEditingController();
  int deliveryStatus = DeliveryStatus.PREPARING.index;
  var deliveryOrderId = -1;
  final formKey = GlobalKey<FormBuilderState>();
  bool codeHasError = false;
  bool phoneHasError = false;
  String createdAt = '';
  String updatedAt = '';
  List<Warehouse> warehouses = [];

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

  var dbService = DataBaseService();
  var connection;
  var bodyList;

  Future<void> refreshDeliveries() async {
    deliveries = await dbService.getRecords(connection, delivery);
    print(deliveries);
    print("REFRESH Deliveries");
    isLoading = false;
  }

  List<dynamic> getData() {
    return deliveries;
  }

  void afterAction() async {
    cleanInputs();
    await refreshDeliveries();
    setNewState();
  }

  void showForm(int? id, BuildContext context) async {
    var deliveryId = 0;

    if (id != null) {
      final deliveryData = deliveries.firstWhere((element) => element.id == id);

      deliveryId = id;
      codeController.text = deliveryData.code;
      nameController.text = deliveryData.name;
      surnameController.text = deliveryData.surname;
      phoneController.text = deliveryData.phone;
      courierIdentificationController.text = deliveryData.courierIdentification;
      deliveryDateController.text = deliveryData.deliveryDate;
      deliveryToController.text = deliveryData.deliveryTo;
      deliveryFromController.text = deliveryData.deliveryFrom;
      deliveryStatus = deliveryData.deliveryStatus;
      deliveryOrderId = deliveryData.deliveryOrderId;
      createdAt = deliveryData.createdAt;
      updatedAt = deliveryData.updatedAt;

      delivery = Delivery(
        createdAt,
        updatedAt,
        id: deliveryId,
        code: deliveryData.code,
        name: deliveryData.name,
        surname: deliveryData.surname,
        phone: deliveryData.phone,
        courierIdentification: deliveryData.courierIdentification,
        deliveryDate: deliveryData.deliveryDate,
        deliveryTo: deliveryData.deliveryTo,
        deliveryFrom: deliveryData.deliveryFrom,
        deliveryStatus: deliveryData.deliveryStatus,
        deliveryOrderId: deliveryData.deliveryOrderId,
      );
    }

    if (deliveries.isEmpty) {
      deliveryId = await dbService.getHighestId(connection, delivery);
    }

    if (deliveryId == 0 && deliveries.isNotEmpty) {
      deliveryId = id ?? deliveries.last.id + 1;
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
                    FormBuilder(
                      key: formKey,
                      onChanged: () {
                        formKey.currentState!.save();
                      },
                      autovalidateMode: AutovalidateMode.disabled,
                      skipDisabled: true,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.always,
                            name: 'code',
                            initialValue: codeController.text,
                            decoration: InputDecoration(
                              labelText: 'Delivery Code',
                              hintText: 'Delivery Code',
                              border: const OutlineInputBorder(),
                              suffixIcon: codeHasError
                                  ? const Icon(Icons.error, color: Colors.red)
                                  : const Icon(Icons.check,
                                      color: Colors.green),
                            ),
                            onChanged: (val) {
                              setState(() {
                                codeHasError = !(formKey
                                        .currentState?.fields['code']
                                        ?.validate() ??
                                    false);

                                if (val != null) {
                                  codeController.text = val;
                                }
                              });
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.equalLength(12),
                            ]),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
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
                          TextField(
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
                          FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.always,
                            name: 'phone',
                            initialValue: phoneController.text,
                            decoration: InputDecoration(
                              labelText: 'Customer Phone',
                              hintText: 'Customer Phone',
                              border: const OutlineInputBorder(),
                              suffixIcon: phoneHasError
                                  ? const Icon(Icons.error, color: Colors.red)
                                  : const Icon(Icons.check,
                                      color: Colors.green),
                            ),
                            onChanged: (val) {
                              setState(() {
                                codeHasError = !(formKey
                                        .currentState?.fields['phone']
                                        ?.validate() ??
                                    false);

                                if (val != null) {
                                  phoneController.text = val;
                                }
                              });
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.match(
                                  r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$'),
                            ]),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: courierIdentificationController,
                            decoration: const InputDecoration(
                              labelText: 'Courier Identification',
                              hintText: 'Courier Identification',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DatePicker(
                            this,
                            deliveryDateController.text,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: deliveryFromController,
                            decoration: const InputDecoration(
                              labelText: 'Delivery Start Location',
                              hintText: 'Delivery Start Location',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: deliveryToController,
                            decoration: const InputDecoration(
                              labelText: 'Delivery Destination Location',
                              hintText: 'Delivery Destination Location',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            height: 200,
                            child: SingleChildScrollView(
                              child: DropDownButton(
                                OrderProvider().getOrderInstance(),
                                deliveryOrderId,
                                this,
                                'deliveryOrderId',
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                        side: BorderSide(
                                            color: Color(0x00000000),
                                            width: 0,
                                            style: BorderStyle.solid),
                                      ),
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.black,
                                      padding: const EdgeInsets.only(
                                          left: 6, right: 6),
                                    ),
                                    onPressed: () async {
                                      delivery = Delivery(
                                        createdAt.isEmpty
                                            ? const DateProvider()
                                                .getDateWithoutTime()
                                            : createdAt,
                                        updatedAt.isEmpty
                                            ? const DateProvider()
                                                .getDateWithoutTime()
                                            : updatedAt,
                                        id: deliveryId,
                                        code: codeController.text,
                                        name: nameController.text,
                                        surname: surnameController.text,
                                        phone: phoneController.text,
                                        courierIdentification:
                                            courierIdentificationController
                                                .text,
                                        deliveryDate:
                                            deliveryDateController.text,
                                        deliveryTo: deliveryToController.text,
                                        deliveryFrom:
                                            deliveryFromController.text,
                                        deliveryStatus: deliveryStatus,
                                        deliveryOrderId: deliveryOrderId,
                                      );

                                      if (deliveryOrderId == -1) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          ErrorSnackBar().getErrorSnackBar(
                                            context,
                                            'Order is required!',
                                          ),
                                        );

                                        return;
                                      }

                                      if (warehouses.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          ErrorSnackBar().getErrorSnackBar(
                                            context,
                                            'You must have a Warehouse to be able to Deliver Products to',
                                          ),
                                        );

                                        return;
                                      }

                                      if (!DeliveryProvider()
                                          .addressesContainWarehouseAddress(
                                              delivery, warehouses)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          ErrorSnackBar().getErrorSnackBar(
                                            context,
                                            'Delivery Destination Location or Delivery Start Location must have currently owned Warehouse Address!',
                                          ),
                                        );

                                        return;
                                      }

                                      if (!(formKey.currentState
                                              ?.saveAndValidate() ??
                                          false)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          ErrorSnackBar().getErrorSnackBar(
                                            context,
                                            'Validation Failed!',
                                          ),
                                        );

                                        return;
                                      }

                                      // Save new journal
                                      if (id == null) {
                                        await addDelivery();
                                      }

                                      if (id != null) {
                                        await updateDelivery();
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
                          ),
                        ],
                      ),
                    ),
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
    courierIdentificationController.text = '';
    deliveryDateController.text = '';
    deliveryToController.text = '';
    deliveryFromController.text = '';
    deliveryOrderId = -1;
    deliveryStatus = DeliveryStatus.PREPARING.index;
    createdAt = '';
    updatedAt = '';
  }

  void setNewState() {
    setState(() {
      this;
    });
  }

  void setNewDropDownButtonValue(int? id, String columnName) {
    if (id == null) {
      return;
    }

    var deliveryData = delivery.toMap();
    deliveryData[columnName] = id;
    delivery = delivery.createModel(deliveryData);

    switch (columnName) {
      case 'deliveryOrderId':
        deliveryOrderId = id;
        break;
      default:
        deliveryStatus = id;
        break;
    }
  }

  void setDeliveryDateController(TextEditingController controller) {
    deliveryDateController = controller;
  }

  Future<void> addDelivery() async {
    await dbService.insertRecord(connection, delivery);
    afterAction();
  }

  Future<void> updateDelivery() async {
    await dbService.updateRecord(connection, delivery);
    afterAction();
  }

  void deleteDelivery(context) async {
    await dbService.deleteRecord(connection, delivery);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text('Successfully deleted a delivery with code: ${delivery.code}!'),
    ));
    afterAction();
  }

  void deleteSelected(List<int> selectedIds, context) async {
    await dbService.deleteSelected(connection, delivery, selectedIds);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully deleted ${selectedIds.length} deliveries!'),
    ));
    afterAction();
  }

  Future<void> initializeNotification() async {
    var notifyProvider = NotifyProvider();

    if (delivery.deliveryStatus == DeliveryStatus.CANCELED.index) {
      await notifyProvider.init(notificationDeliveryCanceledImage);
      notifyProvider.requestIOSPermissions();
      await notifyProvider.scheduleNotifications(
        'Delivery Status',
        'Delivery with code ${delivery.code} has been canceled!',
      );

      await NotificationProvider().saveNotification(
        'Delivery Status',
        'Delivery with code ${delivery.code} has been canceled!',
        deliveryCanceled,
      );
    }

    if (delivery.deliveryStatus == DeliveryStatus.DELIVERED.index) {
      await notifyProvider.init(notificationDeliveryDeliveredImage);
      notifyProvider.requestIOSPermissions();
      await notifyProvider.scheduleNotifications(
        'Delivery Status',
        'Delivery with code ${delivery.code} has been Received!',
      );

      await NotificationProvider().saveNotification(
        'Delivery Status',
        'Delivery with code ${delivery.code} has been Received!',
        deliveryDelivered,
      );
    }

    if (delivery.deliveryStatus == DeliveryStatus.IN_PROGGRESS.index) {
      await notifyProvider.init(notificationDeliveryInProgressImage);
      notifyProvider.requestIOSPermissions();
      await notifyProvider.scheduleNotifications(
        'Delivery Status',
        'Delivery with code ${delivery.code} is being Transported!',
      );

      await NotificationProvider().saveNotification(
        'Delivery Status',
        'Delivery with code ${delivery.code} is being Transported!',
        deliveryInProgress,
      );
    }
  }

  Future<String> getDbConnection() async {
    connection ??= await dbService.getDatabaseConnection(delivery);
    print(connection);
    await refreshDeliveries();
    var warehouseList = await dbService.getRecords(
        connection, WarehouseProvider().getWarehouseInstance());
    warehouses = warehouseList.cast<Warehouse>();

    return '';
  }

  Future<void> changeDeliveryStatusForm(
      BuildContext context, Delivery delivery) async {
    Alert(
      context: context,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
              'Current Delivery Status -> ${DeliveryStatus.values[delivery.deliveryStatus].name}'),
          const SizedBox(
            height: 30,
          ),
          DropdownButtonFormField2(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            isExpanded: true,
            hint: const Text(
              'Select New Delivery Status',
              style: TextStyle(fontSize: 14),
            ),
            items: DeliveryProvider()
                .getDeliveryStatusMapByCurrentStatus(delivery.deliveryStatus)
                .entries
                .map((e) => DropdownMenuItem(
                      value: e.key,
                      child: Text('New Status: ${e.value}'),
                    ))
                .toList(),
            onChanged: (value) async {
              var deliveryData = delivery.toMap();
              deliveryData['deliveryStatus'] = value;
              var tempDelivery = delivery.createModel(deliveryData);

              String checkResults =
                  await DeliveryProvider().checkDeliveryProductsQuantity(
                tempDelivery,
                connection,
                dbService,
                warehouses,
              );

              if (checkResults != '') {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    ErrorSnackBar().getErrorSnackBar(
                      context,
                      checkResults,
                    ),
                  );
                }

                return;
              }

              if (value != null) {
                var deliveryData = delivery.toMap();
                deliveryData['deliveryStatus'] = value;
                this.delivery = delivery.createModel(deliveryData);
                deliveryStatus = value;
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
      buttons: [
        DialogButton(
          child: const Text(
            'SUBMIT',
          ),
          onPressed: () async {
            if (deliveryStatus == delivery.deliveryStatus) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  ErrorSnackBar().getErrorSnackBar(
                    context,
                    'Fix Issues Before Submitting',
                  ),
                );
              }

              if (context.mounted) {
                Navigator.pop(context);
              }

              return;
            }

            var deliveryData = this.delivery.toMap();
            deliveryData['updatedAt'] =
                const DateProvider().getDateWithoutTime();
            this.delivery = delivery.createModel(deliveryData);

            await updateDelivery();
            await DeliveryProvider().updateDeliveryProductsQuantity(
              this.delivery,
              connection,
              dbService,
              warehouses,
            );
            await initializeNotification();

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ],
    ).show();
  }

  Widget bodyBuilder(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicatorWithText('Loading Delivery Data'),
          )
        : deliveries.isNotEmpty
            ? CustomDataTable(DeliveryProvider(), this)
            : Center(
                child: Text(
                'There are no deliveries at the moment!',
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
