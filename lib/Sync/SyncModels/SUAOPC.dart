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
// class SUAOPC {
//   int? ID;
//   String? Code;
//   String? CardCode;
//   String? CreatedBy;
//   String? UpdatedBy;
//   String? BranchId;
//   DateTime? CreateDate;
//   DateTime? UpdateDate;
//   bool? Active;
//   bool? hasCreated;
//   bool? hasUpdated;
//
//   SUAOPC({
//     this.ID,
//     this.Code,
//     this.CardCode,
//     this.CreatedBy,
//     this.UpdatedBy,
//     this.BranchId,
//     this.CreateDate,
//     this.UpdateDate,
//     this.Active,
//     this.hasCreated,
//     this.hasUpdated,
//   });
//
//   factory SUAOPC.fromJson(Map<String, dynamic> json) =>
//       SUAOPC(
//         ID: int.tryParse(json['ID'].toString()) ?? 0,
//         Code: json['Code'],
//         CardCode: json['CardCode'],
//         CreatedBy: json['CreatedBy'],
//         UpdatedBy: json['UpdatedBy'],
//         BranchId: json['BranchId'],
//         CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
//         UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
//         Active: json['Active'] is bool ? json['Active'] : json['Active'] == 1,
//         hasCreated: json['has_created'] is bool
//             ? json['has_created']
//             : json['has_created'] == 1,
//         hasUpdated: json['has_updated'] is bool
//             ? json['has_updated']
//             : json['has_updated'] == 1,
//       );
//
//   Map<String, dynamic> toJson() =>
//       {
//         'ID': ID,
//         'Code': Code,
//         'CardCode': CardCode,
//         'CreatedBy': CreatedBy,
//         'UpdatedBy': UpdatedBy,
//         'BranchId': BranchId,
//         'CreateDate': CreateDate?.toIso8601String(),
//         'UpdateDate': UpdateDate?.toIso8601String(),
//         'Active': Active,
//         'has_created': hasCreated,
//         'has_updated': hasUpdated,
//       };
// }
//
// List<SUAOPC> sUAOPCFromJson(String str) =>
//     List<SUAOPC>.from(json.decode(str).map((x) => SUAOPC.fromJson(x)));
//
// String sUAOPCToJson(List<SUAOPC> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// Future<List<SUAOPC>> dataSyncSUAOPC() async {
//   var res =
//   await http.get(headers: header, Uri.parse(prefix + "SUAOPC" + postfix));
//   print(res.body);
//   return sUAOPCFromJson(res.body);
// }
//
// // Future<void> insertSUAOPC(Database db, {List? list}) async {
// //   if (postfix.toLowerCase().contains('all')) {
// //     await deleteSUAOPC(db);
// //   }
// //   List customers;
// //   if (list != null) {
// //     customers = list;
// //   } else {
// //     customers = await dataSyncSUAOPC();
// //   }
// //   print(customers);
// //   var batch1 = db.batch();
// //   var batch2 = db.batch();
// //   var batch3 = db.batch();
// //   customers.forEach((customer) async {
// //     print(customer.toJson());
// //     try {
// //       batch1.insert('SUAOPC_Temp', customer.toJson());
// //     } catch (e) {
// //       writeToLogFile(
// //           text: e.toString(),
// //           fileName: StackTrace.current.toString(),
// //           lineNo: 141);
// //       getErrorSnackBar('Sync Error ' + e.toString());
// //     }
// //   });
// //   await batch1.commit(noResult: true);
// //   var u = await db.rawQuery(
// //       "SELECT * FROM  SUAOPC_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
// //   u.forEach((element) {
// //     batch2.update("SUAOPC", element,
// //         where: "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
// //         whereArgs: [element["Code"], 1, 1]);
// //   });
// //   await batch2.commit(noResult: true);
// //   await batch2.commit(noResult: true);
// //   var v = await db.rawQuery(
// //       "Select * from SUAOPC_Temp where Code not in (Select Code from SUAOPC)");
// //   v.forEach((element) {
// //     batch3.insert('SUAOPC', element);
// //   });
// //   await batch3.commit(noResult: true);
// //   await db.delete('SUAOPC_Temp');
// // }
// Future<void> insertSUAOPC(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSUAOPC(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSUAOPC();
//   }
//   print(customers);
//   Stopwatch stopwatch = Stopwatch();
//   stopwatch.start();
//   for (var i = 0; i < customers.length; i += batchSize) {
//     var end =
//     (i + batchSize < customers.length) ? i + batchSize : customers.length;
//     var batchRecords = customers.sublist(i, end);
//     await db.transaction((txn) async {
//       var batch = txn.batch();
//       for (SUAOPC record in batchRecords) {
//         try {
//           batch.insert('SUAOPC_Temp', record.toJson());
//         } catch (e) {
//           writeToLogFile(
//               text: e.toString(),
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//           getErrorSnackBar("Sync Error " + e.toString());
//         }
//       }
//       await batch.commit();
//     });
//   }
//   stopwatch.stop();
//   print('Time taken for insert: ${stopwatch.elapsedMilliseconds}ms');
//   stopwatch.reset();
//   stopwatch.start();
//   var differenceList = await db.rawQuery('''
//   Select * from (
// 			select * from SUAOPC_Temp
// 			except
// 			select * from SUAOPC
// 			)A
//   ''');
//   print(differenceList);
//   for (var i = 0; i < differenceList.length; i += batchSize) {
//     var end = (i + batchSize < differenceList.length)
//         ? i + batchSize
//         : differenceList.length;
//     var batchRecords = differenceList.sublist(i, end);
//     await db.transaction((txn) async {
//       var batch = txn.batch();
//       for (var element in batchRecords) {
//         try {
//           batch.update("SUAOPC", element,
//               where: "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//               whereArgs: [element["Code"], 1, 1]);
//         } catch (e) {
//           writeToLogFile(
//               text: e.toString(),
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//           getErrorSnackBar("Sync Error " + e.toString());
//         }
//       }
//       await batch.commit();
//     });
//   }
//
//   stopwatch.stop();
//   print('Time taken for SUAOPC update: ${stopwatch.elapsedMilliseconds}ms');
//   stopwatch.reset();
//   stopwatch.start();
//   // var v = await db.rawQuery("Select * from SUAOPC_Temp where Code not in (Select Code from SUAOPC)");
//   var v = await db.rawQuery('''
//     SELECT T0.*
// FROM SUAOPC_Temp T0
// LEFT JOIN SUAOPC T1 ON T0.Code = T1.Code
// WHERE T1.Code IS NULL;
// ''');
//   for (var i = 0; i < v.length; i += batchSize) {
//     var end = (i + batchSize < v.length) ? i + batchSize : v.length;
//     var batchRecords = v.sublist(i, end);
//     await db.transaction((txn) async {
//       var batch = txn.batch();
//       for (var record in batchRecords) {
//         try {
//           batch.insert('SUAOPC', record);
//         } catch (e) {
//           writeToLogFile(
//               text: e.toString(),
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//           getErrorSnackBar("Sync Error " + e.toString());
//         }
//       }
//       await batch.commit();
//     });
//   }
//   stopwatch.stop();
//   print(
//       'Time taken for SUAOPC_Temp and SUAOPC compare : ${stopwatch.elapsedMilliseconds}ms');
//   stopwatch.reset();
//   print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
//   // stopwatch.start();
//   // // await batch3.commit(noResult: true);
//   await db.delete('SUAOPC_Temp');
//   // stopwatch.stop();
// }
//
// Future<List<SUAOPC>> retrieveSUAOPC(BuildContext context) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult = await db.query('SUAOPC');
//   return queryResult.map((e) => SUAOPC.fromJson(e)).toList();
// }
//
// Future<void> updateSUAOPC(int id, Map<String, dynamic> values,
//     BuildContext context) async {
//   final db = await initializeDB(context);
//   try {
//     db.transaction((db) async {
//       await db.update('SUAOPC', values, where: 'ID = ?', whereArgs: [id]);
//     });
//   } catch (e) {
//     writeToLogFile(text: e.toString(),
//         fileName: StackTrace.current.toString(),
//         lineNo: 141);
//     getErrorSnackBar('Sync Error ' + e.toString());
//   }
// }
//
// Future<void> deleteSUAOPC(Database db) async {
//   await db.delete('SUAOPC');
// }
//
// Future<List<SUAOPC>> retrieveSUAOPCById(BuildContext? context, String str,
//     List l) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//   await db.query('SUAOPC', where: str, whereArgs: l);
//   return queryResult.map((e) => SUAOPC.fromJson(e)).toList();
// }
//
// Future<void> insertSUAOPCToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<SUAOPC> list = await retrieveSUAOPCById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "SUAOPC/Add"),
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
//             .post(Uri.parse(prefix + "SUAOPC/Add"),
//             headers: header, body: jsonEncode(map))
//             .timeout(Duration(seconds: 30), onTimeout: () {
//           writeToLogFile(
//             text: '500 error \nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);return http.Response('Error', 500);
//         });
//         response = await res.body;
//         print("eeaaae status");
//         print(await res.statusCode);
//         if(res.statusCode != 201)
//         {
//           await writeToLogFile(
//               text: '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//         }
//         if (res.statusCode == 201 || res.statusCode == 500) {
//           sentSuccessInServer = true;
//           if (res.statusCode == 201) {
//             map['ID'] = jsonDecode(res.body)['ID'];
//             final Database db = await initializeDB(context);
//             map = jsonDecode(res.body);
//             map["has_created"] = 0;
//             var x = await db.update("SUAOPC", map,
//                 where: "Code = ?", whereArgs: [map["Code"]]);
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
//   } while (i < list.length && sentSuccessInServer ==
//   true
//   );
// }
//
// }
//
// Future<void> updateSUAOPCOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<SUAOPC> list = await retrieveSUAOPCById(
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
//           .put(Uri.parse(prefix + 'SUAOPC/Update'),
//           headers: header, body: jsonEncode(map))
//           .timeout(Duration(seconds: 30), onTimeout: () {
//         writeToLogFile(
//             text: '500 error \nMap : $map', fileName: StackTrace.current.toString(), lineNo: 141);return http.Response('Error', 500);
//       });
//       print(await res.statusCode);
//       if(res.statusCode != 201)
//         {
//           await writeToLogFile(
//               text: '${res.statusCode} error \nMap : $map\nResponse : ${res.body}',
//               fileName: StackTrace.current.toString(),
//               lineNo: 141);
//         }
//         if (res.statusCode == 201 || res.statusCode == 500) {
//         sentSuccessInServer = true;
//         if (res.statusCode == 201) {
//           final Database db = await initializeDB(context);
//           map["has_updated"] = 0;
//           var x = await db.update("SUAOPC", map,
//               where: "Code = ?", whereArgs: [map["Code"]]);
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
