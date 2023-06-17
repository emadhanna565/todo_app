import 'package:intl/intl.dart';

class MyDateUtils {
  static String formatTaskDate(DateTime dateTime) {
    var formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  static DateTime dayOnly(DateTime dateTime) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );
  }
}
