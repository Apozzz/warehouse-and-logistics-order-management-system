import 'package:inventory_system/imports.dart';

class MultiselectDropDownButton extends StatelessWidget {
  var classObject;
  var selectedValuesIds;
  var selectedValuesQuantities;
  var page;

  MultiselectDropDownButton(this.classObject, this.selectedValuesIds,
      this.selectedValuesQuantities, this.page,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiselectDropDownButtonWidget(
      classObject,
      selectedValuesIds,
      selectedValuesQuantities,
      page,
    );
  }
}

class MultiselectDropDownButtonWidget extends StatefulWidget {
  var classObject;
  var selectedValuesIds;
  var selectedValuesQuantities;
  var page;

  MultiselectDropDownButtonWidget(this.classObject, this.selectedValuesIds,
      this.selectedValuesQuantities, this.page,
      {super.key});

  @override
  State<StatefulWidget> createState() => MultiselectDropDownButtonWidgetState();
}

class MultiselectDropDownButtonWidgetState
    extends State<MultiselectDropDownButtonWidget> {
  var values = [];
  List<String>? selectedValues;
  List<String>? selectedValuesQuantities;
  var multiselectValues = {};
  var idQuantity = {};
  var productWarehouseCodes = {};
  var connection;
  var classObject;
  var dbService = DataBaseService();
  bool refreshed = false;

  final _multiSelectKey = GlobalKey<FormFieldState>();

  int? parseSelectedValue(String? selectedValue) {
    return selectedValue != null ? int.parse(selectedValue) : null;
  }

  Future<String> getMultiselectDropDownList() async {
    classObject = widget.classObject;
    connection ??= await dbService.getDatabaseConnection(classObject);
    values = await dbService.getRecords(connection, classObject);
    productWarehouseCodes = await ProductProvider()
        .getProductsWarehouseCodesList(values.cast<Product>());
    selectedValues = !refreshed ? widget.selectedValuesIds : null;
    selectedValuesQuantities =
        !refreshed ? widget.selectedValuesQuantities : null;

    if (selectedValues != null) {
      populateIdQuantityMap(selectedValues!, selectedValuesQuantities!);
    }

    var selectedValuesIds =
        selectedValues?.map((e) => parseSelectedValue(e)).toList();
    var classObjectsById = values
        .where((element) => selectedValuesIds != null
            ? selectedValuesIds.contains(element.id)
            : false)
        .toList();

    selectedValues = classObjectsById.isNotEmpty
        ? classObjectsById.map<String>((e) => e.id.toString()).toList()
        : null;

    if (multiselectValues.isEmpty) {
      populateMultiselectValues();
    }

    return '';
  }

  void populateIdQuantityMap(List<String> ids, List<String> qtys) {
    for (var i = 0; i < ids.length; i++) {
      idQuantity[ids[i]] = qtys[i];
    }
  }

  List<MultiSelectItem> getItemsList() {
    return values
        .map<MultiSelectItem>((e) => MultiSelectItem<String>(
              e.id.toString(),
              'ID: ${e.id.toString()} - NAME: ${e.name} - QTY: ${idQuantity[e.id.toString()] ?? '1'} - WAREHOUSE: ${productWarehouseCodes[e.warehouseId] ?? 'Not Assigned'}',
            ))
        .toList();
  }

  void populateMultiselectValues() {
    var initialValues = [];

    if (selectedValues != null) {
      initialValues.addAll(selectedValues!.cast<dynamic>());
    }

    initialValues = initialValues.toSet().toList();

    for (var value in initialValues) {
      multiselectValues[value] = idQuantity[value];
    }
  }

  void renewPageWidget() {
    if (refreshed) {
      widget.page.setNewMultiselectDropDownButtonValue(
        List<String>.from(multiselectValues.keys.toList()),
        List<String>.from(multiselectValues.values.toList()),
      );
    }
  }

  void mapMultiSelectValues(List<dynamic> values) {
    Map<String, String> newMultiSelectValues = {};

    for (var value in values) {
      if (multiselectValues.containsKey(value)) {
        newMultiSelectValues[value] = multiselectValues[value];
        continue;
      }

      newMultiSelectValues[value] = idQuantity[value];
    }

    multiselectValues = newMultiSelectValues;
  }

  void onSelectionChangedMapIncreased(
      List<dynamic> newValues, String quantity) {
    for (var value in newValues) {
      if (multiselectValues.containsKey(value)) {
        continue;
      }

      idQuantity[value] = quantity;
    }
  }

  void onSelectionChangedMapDecreased(List<dynamic> newValues) {
    for (var id in multiselectValues.keys) {
      if (newValues.contains(id)) {
        continue;
      }

      idQuantity[id] = '1';

      break;
    }
  }

  void recalibrateIdQuantity() {
    for (var id in idQuantity.keys) {
      if (multiselectValues.containsKey(id)) {
        continue;
      }

      idQuantity[id] = '1';
    }
  }

  Widget buildMultiselectDropDownList(BuildContext context) {
    renewPageWidget();
    var items = getItemsList();
    int listLength = multiselectValues.length;

    return items.isEmpty
        ? const Text('No Products To Choose From')
        : Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40),
                MultiSelectBottomSheetField(
                  key: _multiSelectKey,
                  initialChildSize: 0.7,
                  maxChildSize: 0.95,
                  title: const Text('Products'),
                  buttonText: const Text('Ordered Products'),
                  items: items,
                  searchable: true,
                  onSelectionChanged: (list) {
                    TextEditingController quantityController =
                        TextEditingController(text: '1');
                    print('${listLength} SELECTED LIST');
                    print('${list} LIST OF MULTISELECT');

                    if (list.length > listLength) {
                      recalibrateIdQuantity();
                      listLength = list.length;

                      Alert(
                        context: context,
                        title: 'Product Quantity',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: quantityController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                    Icons.production_quantity_limits_outlined),
                                labelText: 'Quantity',
                                hintText: 'Selected Products Quantity',
                                border: OutlineInputBorder(),
                              ),
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
                            onPressed: () {
                              onSelectionChangedMapIncreased(
                                  list, quantityController.text);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ).show();
                    } else {
                      recalibrateIdQuantity();
                      listLength = list.length;
                      onSelectionChangedMapDecreased(list);
                    }

                    print("After cc");
                  },
                  onConfirm: (values) {
                    values = values.toSet().toList();

                    setState(() {
                      mapMultiSelectValues(values);
                      recalibrateIdQuantity();
                      idQuantity = idQuantity;
                      selectedValues = null;
                      refreshed = true;
                    });
                  },
                  initialValue: multiselectValues.keys.toList(),
                  chipDisplay: MultiSelectChipDisplay(
                    height: 20,
                    onTap: (item) {
                      if (multiselectValues != null) {
                        multiselectValues.remove(item);
                      }

                      setState(() {
                        selectedValues = null;
                        multiselectValues = multiselectValues;
                        refreshed = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getMultiselectDropDownList(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Center(child: buildMultiselectDropDownList(context));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
