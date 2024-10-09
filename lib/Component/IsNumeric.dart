import 'package:intl/intl.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';

bool isNumeric(String result) {
  try {
    double.parse(result);
    return true;
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    return false;
  }
}

String displayNumberWithComma(String number) {
  String replacedNumber = number.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
  return replacedNumber;
}

double roundToTwoDecimal(double? value) {
  if (value == null) {
    return 0.0;
  } else {
    return (value * 100).roundToDouble() / 100;
  }
}
double roundToFourDecimal(double? value) {
  if (value == null) {
    return 0.0;
  } else {
    return (value * 10000).roundToDouble() / 10000;
  }
}
double roundToZeroDecimal(double? value) {
  if (value == null) {
    return 0.0;
  } else {
    return (value).roundToDouble();
  }
}

double getNumberWithoutComma(String formattedValue) {
  num numericValue = NumberFormat.decimalPattern().parse(formattedValue);
  return double.tryParse(numericValue.toString()) ?? 0.0;
}
