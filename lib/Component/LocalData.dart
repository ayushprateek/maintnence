// import 'package:shared_preferences/shared_preferences.dart';
//
// class LocalStorage {
//   SharedPreferences? localStorage;
//
//   static LocalStorage? _ls;
//
//   Future<void> initLocalStorage() async {
//     localStorage ??= await SharedPreferences.getInstance();
//   }
//
//   static LocalStorage? getInstance() {
//     _ls ??= LocalStorage();
//     return _ls;
//   }
//
//   static setString({
//     required String key,
//     required String value,
//   }) {
//     LocalStorage.getInstance()?.localStorage?.setString(key, value);
//   }
// }
