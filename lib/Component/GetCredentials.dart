import 'package:maintenance/main.dart';

String getCredentials() {
  return localStorage?.getString('credentials') ?? '';
}

setCredentials({required String credentials}) {
  localStorage?.setString('credentials', credentials);
  if (credentials == '') {
    setLogInTime(dateTime: null);
  } else {
    setLogInTime(dateTime: DateTime.now());
  }
}

setLogInTime({required DateTime? dateTime}) {
  localStorage?.setString('login_date', dateTime?.toIso8601String() ?? '');
}

setSyncDate({required DateTime? dateTime}) {
  localStorage?.setString('syncDate', dateTime?.toIso8601String() ?? '');
}

DateTime? getLogInTime() {
  String str = localStorage?.getString('login_date')?.toString() ?? '';
  return DateTime.tryParse(str);
}

DateTime? getDataSyncDate() {
  String str = localStorage?.getString('syncDate')?.toString() ?? '';
  return DateTime.tryParse(str);
}
DateTime? getFirstTimeDataSyncDate() {
  String str = localStorage?.getString('firstTimeSyncDate')?.toString() ?? '';
  return DateTime.tryParse(str);
}
setFirstTimeSyncDate({required DateTime? dateTime}) {
  localStorage?.setString(
      'firstTimeSyncDate', dateTime?.toIso8601String() ?? '');
}