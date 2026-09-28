import 'package:intl/intl.dart';

String formatLocalDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

int calendarDaysBetween(DateTime from, DateTime to) => DateTime.utc(
  to.year,
  to.month,
  to.day,
).difference(DateTime.utc(from.year, from.month, from.day)).inDays;

const List<String> kIndonesianMonths = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

String formatIndonesianDate(DateTime date) =>
    '${date.day} ${kIndonesianMonths[date.month - 1]} ${date.year}';

String formatLocalizedDate(DateTime date, [String? langCode]) {
  try {
    return DateFormat.yMMMMd(langCode ?? 'id').format(date);
  } catch (_) {
    return formatIndonesianDate(date);
  }
}

