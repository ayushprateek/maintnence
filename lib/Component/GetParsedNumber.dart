import 'package:get/get.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';

int getInt(String str) {
  int i;
  try {
    i = int.parse(str);
  } catch (e) {
    writeToLogFile(text: e.toString(), fileName: StackTrace.current.toString(), lineNo: 141);
    i = 0;
  }
  return i;
}

double getDouble(String str) {
  double d;
  try {
    d = double.parse(str);
  } catch (e) {
    writeToLogFile(text: e.toString(), fileName: StackTrace.current.toString(), lineNo: 141);
    d = 0.0;
  }
  return d;
}
