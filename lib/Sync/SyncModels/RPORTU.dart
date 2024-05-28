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
// class RPORTU {
//   int? ID;
//   String? CreatedBy;
//   int? RoleId;
//   String? RoleShortDesc;
//   String? MenuPath;
//   String? MenuDesc;
//   int? MenuId;
//   bool? Sel;
//   bool? ReadOnly;
//   bool? Self;
//   bool? BranchName;
//   DateTime? CreateDate;
//   DateTime? UpdateDate;
//   bool? Active;
//   bool? CreateAuth;
//   bool? EditAuth;
//   bool? DetailsAuth;
//   bool? FullAuth;
//   String? UpdatedBy;
//   String? BranchId;
//   bool? Company;
//   String? UserCode;
//
//   RPORTU({
//     this.ID,
//     this.CreatedBy,
//     this.RoleId,
//     this.RoleShortDesc,
//     this.MenuPath,
//     this.MenuDesc,
//     this.MenuId,
//     this.Sel,
//     this.ReadOnly,
//     this.Self,
//     this.BranchName,
//     this.CreateDate,
//     this.UpdateDate,
//     this.Active,
//     this.CreateAuth,
//     this.EditAuth,
//     this.DetailsAuth,
//     this.FullAuth,
//     this.UpdatedBy,
//     this.BranchId,
//     this.Company,
//     this.UserCode,
//   });
//
//   factory RPORTU.fromJson(Map<String, dynamic> json) =>
//       RPORTU(
//         ID: int.tryParse(json['ID'].toString()) ?? 0,
//         CreatedBy: json['CreatedBy'],
//         RoleId: int.tryParse(json['RoleId'].toString()) ?? 0,
//         RoleShortDesc: json['RoleShortDesc'],
//         MenuPath: json['MenuPath'],
//         MenuDesc: json['MenuDesc'],
//         MenuId: int.tryParse(json['MenuId'].toString()) ?? 0,
//         Sel: json['Sel'] is bool ? json['Sel'] : json['Sel'] == 1,
//         ReadOnly:
//         json['ReadOnly'] is bool ? json['ReadOnly'] : json['ReadOnly'] == 1,
//         Self: json['Self'] is bool ? json['Self'] : json['Self'] == 1,
//         BranchName: json['BranchName'] is bool
//             ? json['BranchName']
//             : json['BranchName'] == 1,
//         CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
//         UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
//         Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
//         CreateAuth: json['CreateAuth'] is bool
//             ? json['CreateAuth']
//             : json['CreateAuth'] == 1,
//         EditAuth:
//         json['EditAuth'] is bool ? json['EditAuth'] : json['EditAuth'] == 1,
//         DetailsAuth: json['DetailsAuth'] is bool
//             ? json['DetailsAuth']
//             : json['DetailsAuth'] == 1,
//         FullAuth:
//         json['FullAuth'] is bool ? json['FullAuth'] : json['FullAuth'] == 1,
//         UpdatedBy: json['UpdatedBy'],
//         BranchId: json['BranchId'],
//         Company:
//         json['Company'] is bool ? json['Company'] : json['Company'] == 1,
//         UserCode: json['UserCode'],
//       );
//
//   Map<String, dynamic> toJson() =>
//       {
//         'ID': ID,
//         'CreatedBy': CreatedBy,
//         'RoleId': RoleId,
//         'RoleShortDesc': RoleShortDesc,
//         'MenuPath': MenuPath,
//         'MenuDesc': MenuDesc,
//         'MenuId': MenuId,
//         'Sel': Sel,
//         'ReadOnly': ReadOnly,
//         'Self': Self,
//         'BranchName': BranchName,
//         'CreateDate': CreateDate?.toIso8601String(),
//         'UpdateDate': UpdateDate?.toIso8601String(),
//         'Active': Active,
//         'CreateAuth': CreateAuth,
//         'EditAuth': EditAuth,
//         'DetailsAuth': DetailsAuth,
//         'FullAuth': FullAuth,
//         'UpdatedBy': UpdatedBy,
//         'BranchId': BranchId,
//         'Company': Company,
//         'UserCode': UserCode,
//       };
// }
//
// List<RPORTU> rPORTUFromJson(String str) =>
//     List<RPORTU>.from(json.decode(str).map((x) => RPORTU.fromJson(x)));
//
// String rPORTUToJson(List<RPORTU> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// Future<List<RPORTU>> dataSyncRPORTU() async {
//   var res =
//   await http.get(headers: header, Uri.parse(prefix + "RPORTU" + postfix));
//   print(res.body);
//   return rPORTUFromJson(res.body);
// }
//
// Future<void> insertRPORTU(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteRPORTU(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncRPORTU();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('RPORTU_Temp', customer.toJson());
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
//       "SELECT * FROM  RPORTU_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("RPORTU", element,
//         where: "RowId = ? AND TransId = ?",
//         whereArgs: [element["RowId"], element["TransId"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from RPORTU_Temp where TransId || RowId not in (Select TransId || RowId from RPORTU)");
//   v.forEach((element) {
//     batch3.insert('RPORTU', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('RPORTU_Temp');
// }
//
// Future<List<RPORTU>> retrieveRPORTU(BuildContext context) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult = await db.query('RPORTU');
//   return queryResult.map((e) => RPORTU.fromJson(e)).toList();
// }
//
// Future<void> updateRPORTU(int id, Map<String, dynamic> values,
//     BuildContext context) async {
//   final db = await initializeDB(context);
//   try {
//     db.transaction((db) async {
//       await db.update('RPORTU', values, where: 'ID = ?', whereArgs: [id]);
//     });
//   } catch (e) {
//     writeToLogFile(text: e.toString(),
//         fileName: StackTrace.current.toString(),
//         lineNo: 141);
//     getErrorSnackBar('Sync Error ' + e.toString());
//   }
// }
//
// Future<void> deleteRPORTU(Database db) async {
//   await db.delete('RPORTU');
// }
//
// Future<List<RPORTU>> retrieveRPORTUById(BuildContext? context, String str,
//     List l) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//   await db.query('RPORTU', where: str, whereArgs: l);
//   return queryResult.map((e) => RPORTU.fromJson(e)).toList();
// }
//
// Future<void> insertRPORTUToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<RPORTU> list = await retrieveRPORTUById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "RPORTU/Add"),
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
//             .post(Uri.parse(prefix + "RPORTU/Add"),
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
//             var x = await db.update("RPORTU", map,
//                 where: "TransId = ? AND RowId = ?",
//                 whereArgs: [map["TransId"], map["RowId"]]);
//             print(x.toString());
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
//   } while (i < list.length && sentSuccessInServer ==
//   true
//   );
// }
//
// }
//
// Future<void> updateRPORTUOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<RPORTU> list = await retrieveRPORTUById(
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
//           .put(Uri.parse(prefix + 'RPORTU/Update'),
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
//           var x = await db.update("RPORTU", map,
//               where: "TransId = ? AND RowId = ?",
//               whereArgs: [map["TransId"], map["RowId"]]);
//           print(x.toString());
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
