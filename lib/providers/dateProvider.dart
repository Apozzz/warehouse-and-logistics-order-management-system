import 'package:intl/intl.dart' as intl;

class DateProvider {
  const DateProvider();

  String getDateWithoutTime() {
    return intl.DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  }

  String getDateWithTime() {
    return intl.DateFormat('yyyy-MM-dd hh:mm aaa').format(DateTime.now()).toString();
  }
}
