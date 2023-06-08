import 'package:inventory_system/imports.dart';

class DropDownButton extends StatelessWidget {
  var classObject;
  var selectedValueId;
  var page;
  var columnToChange;
  DropDownButton(
      this.classObject, this.selectedValueId, this.page, this.columnToChange,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return DropDownButtonWidget(
      classObject,
      selectedValueId,
      page,
      columnToChange,
    );
  }
}

class DropDownButtonWidget extends StatefulWidget {
  var classObject;
  var selectedValueId;
  var page;
  var columnToChange;
  DropDownButtonWidget(
      this.classObject, this.selectedValueId, this.page, this.columnToChange,
      {super.key});

  @override
  State<StatefulWidget> createState() => DropDownButtonWidgetState();
}

class DropDownButtonWidgetState extends State<DropDownButtonWidget> {
  var values;
  String? selectedValue;
  var connection;
  var classObject;
  var dbService = DataBaseService();

  int? parseSelectedValue(String? selectedValue) {
    return selectedValue != null ? int.parse(selectedValue) : null;
  }

  Future<String> getDropDownList() async {
    classObject = widget.classObject;

    connection ??= await dbService.getDatabaseConnection(classObject);

    values = await dbService.getRecords(connection, classObject);
    var selectedValueId =
        parseSelectedValue(selectedValue) ?? widget.selectedValueId;
    var classObjectById = values.cast<Object?>().firstWhere(
          (element) => element?.id == selectedValueId,
          orElse: () => null,
        );

    selectedValue =
        classObjectById != null ? classObjectById.id.toString() : null;

    return '';
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
                value: e.id.toString(),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(e.code, overflow: TextOverflow.ellipsis),
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getDropDownList(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Center(child: buildDropDownList());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
