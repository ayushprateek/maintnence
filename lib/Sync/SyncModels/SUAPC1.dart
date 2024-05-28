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
// class SUAPC1 {
//   int? ID;
//   String? Code;
//   String? ProjectCode;
//   String? ModuleName;
//   String? Category;
//   String? FormName;
//   DateTime? ValidFrom;
//   DateTime? ValidTo;
//   String? EmpCode;
//   int? NumberOfMobileUser;
//   int? NumberOfWebUser;
//   DateTime? CreateDate;
//   DateTime? UpdateDate;
//   bool? hasCreated;
//   bool? hasUpdated;
//
//   SUAPC1({
//     this.ID,
//     this.Code,
//     this.ProjectCode,
//     this.ModuleName,
//     this.Category,
//     this.FormName,
//     this.ValidFrom,
//     this.ValidTo,
//     this.EmpCode,
//     this.NumberOfMobileUser,
//     this.NumberOfWebUser,
//     this.CreateDate,
//     this.UpdateDate,
//     this.hasCreated,
//     this.hasUpdated,
//   });
//
//   factory SUAPC1.fromJson(Map<String, dynamic> json) =>
//       SUAPC1(
//         ID: int.tryParse(json['ID'].toString()) ?? 0,
//         Code: json['Code'],
//         ProjectCode: json['ProjectCode'],
//         ModuleName: json['ModuleName'],
//         Category: json['Category'],
//         FormName: json['FormName'],
//         ValidFrom: DateTime.tryParse(json['ValidFrom'].toString()),
//         ValidTo: DateTime.tryParse(json['ValidTo'].toString()),
//         EmpCode: json['EmpCode'],
//         NumberOfMobileUser:
//         int.tryParse(json['NumberOfMobileUser'].toString()) ?? 0,
//         NumberOfWebUser: int.tryParse(json['NumberOfWebUser'].toString()) ?? 0,
//         CreateDate: DateTime.tryParse(json['CreateDate'].toString()),
//         UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()),
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
//         'ProjectCode': ProjectCode,
//         'ModuleName': ModuleName,
//         'Category': Category,
//         'FormName': FormName,
//         'ValidFrom': ValidFrom?.toIso8601String(),
//         'ValidTo': ValidTo?.toIso8601String(),
//         'EmpCode': EmpCode,
//         'NumberOfMobileUser': NumberOfMobileUser,
//         'NumberOfWebUser': NumberOfWebUser,
//         'CreateDate': CreateDate?.toIso8601String(),
//         'UpdateDate': UpdateDate?.toIso8601String(),
//         'has_created': hasCreated,
//         'has_updated': hasUpdated,
//       };
// }
//
// List<SUAPC1> sUAPC1FromJson(String str) =>
//     List<SUAPC1>.from(json.decode(str).map((x) => SUAPC1.fromJson(x)));
//
// String sUAPC1ToJson(List<SUAPC1> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// Future<List<SUAPC1>> dataSyncSUAPC1() async {
//   var res =
//   await http.get(headers: header, Uri.parse(prefix + "SUAPC1" + postfix));
//   print(res.body);
//   return sUAPC1FromJson(res.body);
// }
//
// // Future<void> insertSUAPC1(Database db, {List? list}) async {
// //   if (postfix.toLowerCase().contains('all')) {
// //     await deleteSUAPC1(db);
// //   }
// //   List customers;
// //   if (list != null) {
// //     customers = list;
// //   } else {
// //     customers = await dataSyncSUAPC1();
// //   }
// //   print(customers);
// //   var batch1 = db.batch();
// //   var batch2 = db.batch();
// //   var batch3 = db.batch();
// //   customers.forEach((customer) async {
// //     print(customer.toJson());
// //     try {
// //       batch1.insert('SUAPC1_Temp', customer.toJson());
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
// //       "SELECT * FROM  SUAPC1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
// //   u.forEach((element) {
// //     batch2.update("SUAPC1", element,
// //         where: "Code = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
// //         whereArgs: [element["Code"], 1, 1]);
// //   });
// //   await batch2.commit(noResult: true);
// //   await batch2.commit(noResult: true);
// //   var v = await db.rawQuery(
// //       "Select * from SUAPC1_Temp where Code not in (Select Code from SUAPC1)");
// //   v.forEach((element) {
// //     batch3.insert('SUAPC1', element);
// //   });
// //   await batch3.commit(noResult: true);
// //   await db.delete('SUAPC1_Temp');
// // }
// Future<void> insertSUAPC1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSUAPC1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSUAPC1();
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
//       for (SUAPC1 record in batchRecords) {
//         try {
//           batch.insert('SUAPC1_Temp', record.toJson());
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
// 			select * from SUAPC1_Temp
// 			except
// 			select * from SUAPC1
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
//           batch.update("SUAPC1", element,
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
//   print('Time taken for SUAPC1 update: ${stopwatch.elapsedMilliseconds}ms');
//   stopwatch.reset();
//   stopwatch.start();
//   // var v = await db.rawQuery("Select * from SUAPC1_Temp where Code not in (Select Code from SUAPC1)");
//   var v = await db.rawQuery('''
//     SELECT T0.*
// FROM SUAPC1_Temp T0
// LEFT JOIN SUAPC1 T1 ON T0.Code = T1.Code
// WHERE T1.Code IS NULL;
// ''');
//   for (var i = 0; i < v.length; i += batchSize) {
//     var end = (i + batchSize < v.length) ? i + batchSize : v.length;
//     var batchRecords = v.sublist(i, end);
//     await db.transaction((txn) async {
//       var batch = txn.batch();
//       for (var record in batchRecords) {
//         try {
//           batch.insert('SUAPC1', record);
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
//       'Time taken for SUAPC1_Temp and SUAPC1 compare : ${stopwatch.elapsedMilliseconds}ms');
//   stopwatch.reset();
//   print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
//   // stopwatch.start();
//   // // await batch3.commit(noResult: true);
//   await db.delete('SUAPC1_Temp');
//   // stopwatch.stop();
// }
//
// Future<List<SUAPC1>> retrieveSUAPC1(BuildContext context) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult = await db.query('SUAPC1');
//   return queryResult.map((e) => SUAPC1.fromJson(e)).toList();
// }
//
// Future<void> updateSUAPC1(int id, Map<String, dynamic> values,
//     BuildContext context) async {
//   final db = await initializeDB(context);
//   try {
//     db.transaction((db) async {
//       await db.update('SUAPC1', values, where: 'ID = ?', whereArgs: [id]);
//     });
//   } catch (e) {
//     writeToLogFile(text: e.toString(),
//         fileName: StackTrace.current.toString(),
//         lineNo: 141);
//     getErrorSnackBar('Sync Error ' + e.toString());
//   }
// }
//
// Future<void> deleteSUAPC1(Database db) async {
//   await db.delete('SUAPC1');
// }
//
// Future<List<SUAPC1>> retrieveSUAPC1ById(BuildContext? context, String str,
//     List l) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//   await db.query('SUAPC1', where: str, whereArgs: l);
//   return queryResult.map((e) => SUAPC1.fromJson(e)).toList();
// }
//
// Future<void> insertSUAPC1ToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<SUAPC1> list = await retrieveSUAPC1ById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "SUAPC1/Add"),
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
//             .post(Uri.parse(prefix + "SUAPC1/Add"),
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
//             var x = await db.update("SUAPC1", map,
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
// Future<void> updateSUAPC1OnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<SUAPC1> list = await retrieveSUAPC1ById(
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
//           .put(Uri.parse(prefix + 'SUAPC1/Update'),
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
//           var x = await db.update("SUAPC1", map,
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
