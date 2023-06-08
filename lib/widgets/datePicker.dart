import 'package:intl/intl.dart';
import 'package:inventory_system/imports.dart';

class DatePicker extends StatelessWidget {
  var page;
  var selectedDate;

  DatePicker(this.page, this.selectedDate, {super.key});

  @override
  Widget build(BuildContext context) {
    return DatePickerWidget(
      page,
      selectedDate,
    );
  }
}

class DatePickerWidget extends StatefulWidget {
  var page;
  var selectedDate;

  DatePickerWidget(this.page, this.selectedDate, {super.key});

  @override
  DatePickerWidgetState createState() => DatePickerWidgetState();
}

class DatePickerWidgetState extends State<DatePickerWidget> {
  var height;
  var width;
  var setDate;
  var dateTime;
  var selectedDate;
  TextEditingController dateController = TextEditingController();

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime.now(),
      lastDate: DateTime(selectedDate.year + 20),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate).toString();
        widget.page.setDeliveryDateController(dateController);
      });
    }
  }

  TextEditingController getDateController() {
    return dateController;
  }

  @override
  void initState() {
    selectedDate = widget.selectedDate.isNotEmpty
        ? DateFormat('yyyy-MM-dd').parse(widget.selectedDate)
        : DateTime.now();
    dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return TextField(
      controller: dateController,
      decoration: const InputDecoration(
        labelText: 'Date Of Delivery',
        hintText: 'Date Of Delivery',
        border: OutlineInputBorder(),
      ),
      onTap: () {
        selectDate(context);
      },
    );
  }
}
