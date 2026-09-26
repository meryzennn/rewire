import 'package:flutter_test/flutter_test.dart';
import 'package:rewire/core/utils/date_utils.dart';

void main() {
  test('formats local calendar dates without UTC conversion', () {
    expect(formatLocalDate(DateTime(2024, 3, 1, 0, 5)), '2024-03-01');
    expect(formatLocalDate(DateTime(2024, 12, 31, 23, 59)), '2024-12-31');
  });

  test(
    'counts consecutive local calendar dates across month and year rollover',
    () {
      expect(
        calendarDaysBetween(DateTime(2023, 12, 31), DateTime(2024, 1, 1)),
        1,
      );
      expect(
        calendarDaysBetween(DateTime(2024, 2, 28), DateTime(2024, 3, 1)),
        2,
      );
      expect(
        calendarDaysBetween(DateTime(2024, 2, 29), DateTime(2024, 3, 1)),
        1,
      );
    },
  );

  test('normalizes time of day before counting calendar dates', () {
    expect(
      calendarDaysBetween(DateTime(2024, 3, 1, 23, 59), DateTime(2024, 3, 2)),
      1,
    );
    expect(
      calendarDaysBetween(DateTime(2024, 3, 2), DateTime(2024, 3, 1, 0, 1)),
      -1,
    );
  });
}
