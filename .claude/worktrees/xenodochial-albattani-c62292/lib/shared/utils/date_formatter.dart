import 'package:intl/intl.dart';

String formatShortDate(DateTime date, String locale) {
  return DateFormat.yMd(locale).format(date);
}

String formatDayMonth(DateTime date, String locale) {
  return DateFormat.Md(locale).format(date);
}
