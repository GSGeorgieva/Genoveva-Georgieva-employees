import 'package:intl/intl.dart';

DateTime parseDateFromRegExp(RegExp re, String dateTimeString) {
  var match = re.firstMatch(dateTimeString);
  if (match == null) {
    throw FormatException('Failed to parse: $dateTimeString');
  }

  var year = match.namedGroup('year');
  var month = match.namedGroup('month');
  var day = match.namedGroup('day');

  if (year == null || month == null || day == null) {
    throw ArgumentError('Regular expression is malformed');
  }

  return DateFormat('yy-MM-dd').parse('$year-$month-$day');
}

typedef DateParser = DateTime Function(String);

DateParser dateParserFromRegExp(String rePattern) =>
    (string) => parseDateFromRegExp(RegExp(rePattern), string);


var parserList = [
  DateFormat('yyyy-MM-dd').parse,
  DateFormat('MMM-yyyy').parse,
  DateFormat('MM/dd/yy').parse,
  dateParserFromRegExp(
    r'^(?<month>\d{2})(?<day>\d{2})(?<year>\d{4})$',
  )
];

DateTime? parseDateCustom(String? timeStamp) {
  if (timeStamp == null) return null;
  DateTime? result;
  for (var tryParse in parserList) {
    try {
      result = tryParse(timeStamp);
    } on Exception {}
  }
  return result;
}
