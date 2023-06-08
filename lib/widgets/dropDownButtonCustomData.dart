import 'package:inventory_system/imports.dart';

class DropDownButtonCustomData extends StatelessWidget {
  var customData;
  var selectedValueId;
  var page;
  var columnToChange;
  DropDownButtonCustomData(
      this.customData, this.selectedValueId, this.page, this.columnToChange,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return DropDownButtonCustomDataWidget(
      customData,
      selectedValueId,
      page,
      columnToChange,
    );
  }
}

class DropDownButtonCustomDataWidget extends StatefulWidget {
  var customData;
  var selectedValueId;
  var page;
  var columnToChange;
  DropDownButtonCustomDataWidget(
      this.customData, this.selectedValueId, this.page, this.columnToChange,
      {super.key});

  @override
  State<StatefulWidget> createState() => DropDownButtonCustomDataWidgetState();
}

class DropDownButtonCustomDataWidgetState
    extends State<DropDownButtonCustomDataWidget> {
  var values;
  String? selectedValue;
  var connection;
  var dbService = DataBaseService();

  int? parseSelectedValue(String? selectedValue) {
    return selectedValue != null ? int.parse(selectedValue) : null;
  }

  void init() {
    values = widget.customData;
    selectedValue = selectedValue ?? widget.selectedValueId.toString();
  }

  Widget buildDropDownList() {
    return DropdownButton2(
      isExpanded: true,
      hint: const Text('Please choose an Item'),
      value: selectedValue,
      onChanged: (newValue) {
        widget.page.setNewDropDownButtonValue(
            parseSelectedValue(newValue), widget.columnToChange);

        setState(() {
          selectedValue = newValue!;
        });
      },
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: values
          .map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                value: e.index.toString(),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(values[e.index].toString(), overflow: TextOverflow.ellipsis),
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Center(child: buildDropDownList());
  }
}
