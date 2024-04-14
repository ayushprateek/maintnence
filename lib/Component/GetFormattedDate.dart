import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance/Sync/SyncModels/SecondaryCalendar.dart';

String dateFormat = 'dd-MM-yyyy';

String getFormattedDate(DateTime? now) {
  if (now == null) {
    now = DateTime.parse("1900-01-01");
    DateFormat formatter = DateFormat(dateFormat);
    String formatted = formatter.format(now);
    return formatted;
  } else {
    DateFormat formatter = DateFormat(dateFormat);
    String formatted = formatter.format(now);
    return formatted;
  }
}
String formatTimeOfDay(TimeOfDay timeOfDay) {
  final now = DateTime.now();
  final dateTime =
  DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  final formattedTime = DateFormat.jm().format(dateTime);
  return formattedTime;
}

String getFormattedDateAndTime(DateTime? now) {
  DateFormat formatter = DateFormat('$dateFormat HH:mm a');
  if (now != null) {
    String formatted = formatter.format(now);
    return formatted;
  }
  String formatted = "";
  return formatted;
}
DateTime getDateAndTimeFromString(String? now) {
  if (now == null || now == '') {
    return DateTime.parse("1900-01-01");
  }
  DateTime tempDate = DateFormat('$dateFormat HH:mm a').parse(now);
  return tempDate;
}

DateTime getDateFromString(String? now) {
  if (now == null || now == '') {
    return DateTime.parse("1900-01-01");
  }
  DateTime tempDate = DateFormat(dateFormat).parse(now);
  return tempDate;
}

DateTime getTimeFromString(String? time) {
  if (time == null || time == '') {
    return DateTime.parse("1900-01-01");
  }
  // time = "12:24 PM";

  // Parse time string into a DateTime object
  DateTime parsedTime = DateFormat.jm().parse(time);

  print(parsedTime); // Output: 1970-01-01 12:24:00.000
  return parsedTime;
  DateTime date = DateFormat('HH:mm').parse(time);
  print(date.toIso8601String());
  return date;
}

String getStringFromTime(DateTime? time) {
  if (time == null || time == '') {
    return '';
  }
  String formattedTime = DateFormat.jm().format(time);
  print(formattedTime);
  return formattedTime;
}

Future<String> getLocalDate(DateTime date) async {
  date = getDateFromString(getFormattedDate(date));
  DateFormat formatter = DateFormat('dd/MM/yyyy');
  String formatted = formatter.format(date);
  print(formatted);
  List<SecondaryCalendar> list = await retrieveSecondaryCalendarById(
      null, "strftime('%d/%m/%Y', EnglishDate) = ?", [formatted]);
  String SecondaryDate = '';

  if (list.isNotEmpty) {
    SecondaryDate = list[0].SecondaryDate ?? '';
  }
  return SecondaryDate;
}
