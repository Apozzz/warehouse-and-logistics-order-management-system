import 'package:intl/intl.dart';

class CustomDateUtils {
  static String formatDate(DateTime date) {
    final format = DateFormat('yyyy-MM-dd hh:mm aaa');
    return format.format(date);
  }

  static DateTime parseDate(String dateString) {
    final format = DateFormat('yyyy-MM-dd hh:mm aaa');
    return format.parse(dateString);
  }
}
