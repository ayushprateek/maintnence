// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:maintenance/Component/LogFileFunctions.dart';
// import 'package:maintenance/Component/SnackbarComponent.dart';
// import 'package:maintenance/DatabaseInitialization.dart';
// import 'package:maintenance/Sync/CustomURL.dart';
// import 'package:maintenance/Sync/DataSync.dart';
// import 'package:sqflite/sqlite_api.dart';
//
// class Rights {
//   double? ID;
//   int? EmployeeId;
//   String? Controller;
//   String? Action;
//   bool? Allowed;
//   bool? MenuView;
//   String? Text;
//   String? Description;
//
//   Rights({
//     this.ID,
//     this.EmployeeId,
//     this.Controller,
//     this.Action,
//     this.Allowed,
//     this.MenuView,
//     this.Text,
//     this.Description,
//   });
//
//   factory Rights.fromJson(Map<String, dynamic> json) =>
//       Rights(
//         ID: double.tryParse(json['ID'].toString()) ?? 0.0,
//         EmployeeId: int.tryParse(json['EmployeeId'].toString()) ?? 0,
//         Controller: json['Controller'] ?? '',
//         Action: json['Action'] ?? '',
//         Allowed:
//         json['Allowed'] is bool ? json['Allowed'] : json['Allowed'] == 1,
//         MenuView:
//         json['MenuView'] is bool ? json['MenuView'] : json['MenuView'] == 1,
//         Text: json['Text'] ?? '',
//         Description: json['Description'] ?? '',
//       );
//
//   Map<String, dynamic> toJson() =>
//       {
//         'ID': ID,
//         'EmployeeId': EmployeeId,
//         'Controller': Controller,
//         'Action': Action,
//         'Allowed': Allowed,
//         'MenuView': MenuView,
//         'Text': Text,
//         'Description': Description,
//       };
// }
//
// List<Rights> rightsFromJson(String str) =>
//     List<Rights>.from(json.decode(str).map((x) => Rights.fromJson(x)));
//
// String rightsToJson(List<Rights> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// Future<List<Rights>> dataSyncRights() async {
//   var res =
//   await http.get(headers: header, Uri.parse(prefix + "Rights" + postfix));
//   print(res.body);
//   return rightsFromJson(res.body);
// }
//
// Future<void> insertRights(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteRights(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncRights();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('Rights_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar('Sync Error ' + e.toString());
//     }
//   });
//   await batch1.commit(noResult: true);
//   var u = await db.rawQuery(
//       "SELECT * FROM  Rights_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("Rights", element,
//         where: "RowId = ? AND TransId = ?",
//         whereArgs: [element["RowId"], element["TransId"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from Rights_Temp where TransId || RowId not in (Select TransId || RowId from Rights)");
//   v.forEach((element) {
//     batch3.insert('Rights', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('Rights_Temp');
// }
//
// Future<List<Rights>> retrieveRights(BuildContext context) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult = await db.query('Rights');
//   return queryResult.map((e) => Rights.fromJson(e)).toList();
// }
//
// Future<void> updateRights(int id, Map<String, dynamic> values,
//     BuildContext context) async {
//   final db = await initializeDB(context);
//   try {
//     db.transaction((db) async {
//       await db.update('Rights', values, where: 'ID = ?', whereArgs: [id]);
//     });
//   } catch (e) {
//     writeToLogFile(text: e.toString(),
//         fileName: StackTrace.current.toString(),
//         lineNo: 141);
//     getErrorSnackBar('Sync Error ' + e.toString());
//   }
// }
//
// Future<void> deleteRights(Database db) async {
//   await db.delete('Rights');
// }
//
// Future<List<Rights>> retrieveRightsById(BuildContext? context, String str,
//     List l) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//   await db.query('Rights', where: str, whereArgs: l);
//   return queryResult.map((e) => Rights.fromJson(e)).toList();
// }
//
// Future<void> insertRightsToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<Rights> list = await retrieveRightsById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "Rights/Add"),
//         headers: header, body: jsonEncode(list[0].toJson()));
//     response = res.body;
//   } else if (list.isNotEmpty) {
//     int i = 0;
//     bool sentSuccessInServer = false;
//     if (list.isEmpty) {
//       return;
//     }
//     do {Map<String, dynamic> map = list[i].toJson();
//       sentSuccessInServer = false;
//       try {
//         map.remove('ID');
//         var res = await http
//             .post(Uri.parse(prefix + "Rights/Add"),
//             headers: header, body: jsonEncode(map))
//             .timeout(Duration(seconds: 30), onTimeout: () {
//           writeToLogFile(
//             text: '500 error \nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);return http.Response('Error', 500);
//         });
//         response = await res.body;
//         print("eeaaae status");
//         print(await res.statusCode);
//         if (res.statusCode == 201 || res.statusCode == 500) {
//           sentSuccessInServer = true;
//           if (res.statusCode == 201) {
//             map['ID'] = jsonDecode(res.body)['ID'];
//             final Database db = await initializeDB(context);
//             map = jsonDecode(res.body);
//             map["has_created"] = 0;
//             var x = await db.update("Rights", map,
//                 where: "TransId = ? AND RowId = ?",
//                 whereArgs: [map["TransId"], map["RowId"]]);
//             print(x.toString());
//           }else{
//             writeToLogFile(
//                 text: '500 error \nMap : $map',
//                 fileName: StackTrace.current.toString(),
//                 lineNo: 141);
//           }
//         }
//         print(res.body);
//       } catch (e) {
//         writeToLogFile(
//             text: '${e.toString()}\nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);
//   sentSuccessInServer = true;
//   }
//   i++;
//   print("INDEX = " + i.toString());
//   } while (i < list.length && sentSuccessInServer == true);
// }
//
// }
//
// Future<void> updateRightsOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<Rights> list = await retrieveRightsById(
//       context,
//       l == null ? DataSync.getUpdateOnServerStr() : condition ?? "",
//       l == null ? DataSync.getUpdateOnServerList() : l);
//   print(list);
//   int i = 0;
//   bool sentSuccessInServer = false;
//   if (list.isEmpty) {
//     return;
//   }
//   do {Map<String, dynamic> map = list[i].toJson();
//     sentSuccessInServer = false;
//     try {
//       if (list.isEmpty) {
//         return;
//       }
//       Map<String, dynamic> map = list[i].toJson();
//       var res = await http
//           .put(Uri.parse(prefix + 'Rights/Update'),
//           headers: header, body: jsonEncode(map))
//           .timeout(Duration(seconds: 30), onTimeout: () {
//         writeToLogFile(
//             text: '500 error \nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);return http.Response('Error', 500);
//       });
//       print(await res.statusCode);
//       if (res.statusCode == 201 || res.statusCode == 500) {
//         sentSuccessInServer = true;
//         if (res.statusCode == 201) {
//           final Database db = await initializeDB(context);
//           map["has_updated"] = 0;
//           var x = await db.update("Rights", map,
//               where: "TransId = ? AND RowId = ?",
//               whereArgs: [map["TransId"], map["RowId"]]);
//           print(x.toString());
//         }else{
//           writeToLogFile(
//               text: '500 error \nMap : $map',
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//         }
//       }
//       print(res.body);
//     } catch (e) {
//       writeToLogFile(
//           text: '${e.toString()}\nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);
//   sentSuccessInServer = true;
//   }
//
//   i++;
//   print("INDEX = " + i.toString());
//   } while (i < list.length && sentSuccessInServer == true);
// }
