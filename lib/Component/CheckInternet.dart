import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';

Future<bool> isInternetAvailable() async {
  try {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
    // return false;
  } catch (e) {
    writeToLogFile(text: e.toString(), fileName: StackTrace.current.toString(), lineNo: 141);
    print(e.toString());
    return false;
  }
}
