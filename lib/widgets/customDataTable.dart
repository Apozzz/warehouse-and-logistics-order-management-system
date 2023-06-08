import 'package:inventory_system/imports.dart';

class CustomDataTable extends StatelessWidget {
  var provider;
  var page;

  CustomDataTable(this.provider, this.page, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDataTableWidget(
      provider,
      page,
    );
  }
}

class CustomDataTableWidget extends StatefulWidget {
  var provider;
  var page;

  CustomDataTableWidget(this.provider, this.page, {super.key});

  @override
  State<CustomDataTableWidget> createState() => CustomDataTableWidgetState();
}

class CustomDataTableWidgetState extends State<CustomDataTableWidget> {
  List<Text> columnsNames = [];
  List<dynamic> data = [];
  List<Object> filteredData = [];
  List<String> dataColumns = [];
  int sortColumnIndex = 1;
  bool sort = true;
  bool filtered = false;
  var provider;
  var page;
  List<int> selectedRows = [];
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();

    provider = widget.provider;
    dataColumns = provider.getColumns();
    columnsNames = provider.getTableColumnsNames();
    page = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    data = page.getData();

    if (!filtered) {
      filteredData = data.cast<Object>();
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PaginatedDataTable(
            actions: [
              selectedRows.isNotEmpty
                  ? ElevatedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
                                  onPressed: () async {
                                    await page.deleteSelected(
                                      selectedRows,
                                      context,
                                    );
                                    Navigator.pop(context, true);
                                    setState(() {
                                      selectedRows = [];
                                    });
                                  },
                                  child: Text(
                                    'Delete'.toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).show();
                      },
                      icon: const Icon(
                        Icons.remove,
                        size: 16,
                        color: Colors.white,
                        weight: 2,
                      ),
                      label: Text(
                        'Delete Selected'.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : const SizedBox(),
            ],
            columns: getColumns(),
            source: CustomDataTableSource(
                filteredData, selectedRows, context, page, provider, this),
            rowsPerPage: data.length > 15
                ? 15
                : data.isEmpty
                    ? 1
                    : data.length,
            sortColumnIndex: sortColumnIndex,
            sortAscending: sort,
            header: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: Wrap(
                children: [
                  TextField(
                    controller: search,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: "Enter value to search",
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredData = data
                            .cast<Object>()
                            .where((element) => isInSearch(element, value))
                            .toList();
                        filtered = true;

                        if (value == '') {
                          filtered = false;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isInSearch(element, value) {
    element = element.toMap();

    for (var item in element.values) {
      if (item.runtimeType != String) {
        item = item.toString();
      }

      if (item.contains(value)) {
        return true;
      }
    }

    return false;
  }

  List<DataColumn> getColumns() {
    List<DataColumn> tableDataColumns = [];
    tableDataColumns = columnsNames.map<DataColumn>((item) {
      return DataColumn(
        label: item,
        onSort: (columnIndex, _) {
          if (columnIndex == 0) {
            return;
          }

          setState(() {
            sortColumnIndex = columnIndex;
            columnIndex--;
            if (sort == true) {
              sort = false;
              data.sort((firstItem, secondItem) =>
                  (secondItem.toMap()[dataColumns[columnIndex]] ?? '')
                      .compareTo(
                          (firstItem.toMap()[dataColumns[columnIndex]] ?? '')));
            } else {
              sort = true;
              data.sort((firstItem, secondItem) =>
                  (firstItem.toMap()[dataColumns[columnIndex]] ?? '').compareTo(
                      (secondItem.toMap()[dataColumns[columnIndex]] ?? '')));
            }
          });
        },
      );
    }).toList();

    return tableDataColumns;
  }
}

class CustomDataTableSource extends DataTableSource {
  var data;
  var selectedRows;
  var page;
  var provider;
  var state;
  int selectedCount = 0;
  BuildContext context;

  CustomDataTableSource(this.data, this.selectedRows, this.context, this.page,
      this.provider, this.state);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);

    if (index >= data.length) return null;

    final row = data[index];

    return getDataRow(row);
  }

  DataRow getDataRow(var data) {
    bool selected = selectedRows.contains(data.id);
    List<DataCell> dataCells = provider.getDataCellList(data, context, page);

    return DataRow(
      cells: dataCells,
      selected: selected,
      onSelectChanged: (value) {
        if (selected != value) {
          selectedCount = selectedRows.length;
          assert(selectedCount >= 0);

          if (value == false) {
            if (selectedRows.contains(data.id)) {
              selectedRows.remove(data.id);
              selectedCount--;
            }
          } else {
            selectedRows.add(data.id);
            selectedCount++;
          }

          notifyListeners();
          state.setState(
            () => selectedRows = selectedRows,
          );
        }
      },
    );
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => selectedCount;
}
