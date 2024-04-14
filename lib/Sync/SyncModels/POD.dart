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
// class POD {
//   double? Auto;
//   String? POId;
//   int? PODId;
//   int? ProductId;
//   double? OpeningStock;
//   int? Quantity;
//   double? PurchasePrice;
//   double? PerPack;
//   bool? IsPack;
//   bool? SaleType;
//   String? Remarks;
//
//   POD({
//     this.Auto,
//     this.POId,
//     this.PODId,
//     this.ProductId,
//     this.OpeningStock,
//     this.Quantity,
//     this.PurchasePrice,
//     this.PerPack,
//     this.IsPack,
//     this.SaleType,
//     this.Remarks,
//   });
//
//   factory POD.fromJson(Map<String, dynamic> json) =>
//       POD(
//         Auto: double.tryParse(json['Auto'].toString()) ?? 0.0,
//         POId: json['POId'] ?? '',
//         PODId: int.tryParse(json['PODId'].toString()) ?? 0,
//         ProductId: int.tryParse(json['ProductId'].toString()) ?? 0,
//         OpeningStock: double.tryParse(json['OpeningStock'].toString()) ?? 0.0,
//         Quantity: int.tryParse(json['Quantity'].toString()) ?? 0,
//         PurchasePrice: double.tryParse(json['PurchasePrice'].toString()) ?? 0.0,
//         PerPack: double.tryParse(json['PerPack'].toString()) ?? 0.0,
//         IsPack: json['IsPack'] is bool ? json['IsPack'] : json['IsPack'] == 1,
//         SaleType:
//         json['SaleType'] is bool ? json['SaleType'] : json['SaleType'] == 1,
//         Remarks: json['Remarks'] ?? '',
//       );
//
//   Map<String, dynamic> toJson() =>
//       {
//         'Auto': Auto,
//         'POId': POId,
//         'PODId': PODId,
//         'ProductId': ProductId,
//         'OpeningStock': OpeningStock,
//         'Quantity': Quantity,
//         'PurchasePrice': PurchasePrice,
//         'PerPack': PerPack,
//         'IsPack': IsPack,
//         'SaleType': SaleType,
//         'Remarks': Remarks,
//       };
// }
//
// List<POD> pODFromJson(String str) =>
//     List<POD>.from(json.decode(str).map((x) => POD.fromJson(x)));
//
// String pODToJson(List<POD> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// Future<List<POD>> dataSyncPOD() async {
//   var res =
//   await http.get(headers: header, Uri.parse(prefix + "POD" + postfix));
//   print(res.body);
//   return pODFromJson(res.body);
// }
//
// // Future<void> insertPOD(Database db, {List? list}) async {
// //   if (postfix.toLowerCase().contains('all')) {
// //     await deletePOD(db);
// //   }
// //   List customers;
// //   if (list != null) {
// //     customers = list;
// //   } else {
// //     customers = await dataSyncPOD();
// //   }
// //   print(customers);
// //   var batch1 = db.batch();
// //   var batch2 = db.batch();
// //   var batch3 = db.batch();
// //   customers.forEach((customer) async {
// //     print(customer.toJson());
// //     try {
// //       batch1.insert('POD_Temp', customer.toJson());
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
// //       "SELECT * FROM  POD_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
// //   u.forEach((element) {
// //     batch2.update("POD", element,
// //         where: "RowId = ? AND TransId = ?",
// //         whereArgs: [element["RowId"], element["TransId"]]);
// //   });
// //   await batch2.commit(noResult: true);
// //   await batch2.commit(noResult: true);
// //   var v = await db.rawQuery(
// //       "Select * from POD_Temp where TransId || RowId not in (Select TransId || RowId from POD)");
// //   v.forEach((element) {
// //     batch3.insert('POD', element);
// //   });
// //   await batch3.commit(noResult: true);
// //   await db.delete('POD_Temp');
// // }
// Future<void> insertPOD(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deletePOD(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncPOD();
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
//       for (POD record in batchRecords) {
//         try {
//           batch.insert('POD_Temp', record.toJson());
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
// 			select * from POD_Temp
// 			except
// 			select * from POD
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
//           batch.update("POD", element,
//               where: "RowId = ? AND TransId = ?",
//               whereArgs: [element["RowId"], element["TransId"]]);
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
//   print('Time taken for POD update: ${stopwatch.elapsedMilliseconds}ms');
//   stopwatch.reset();
//   stopwatch.start();
//   var v = await db.rawQuery(
//       "Select * from POD_Temp where TransId || RowId not in (Select TransId || RowId from POD)");
//   for (var i = 0; i < v.length; i += batchSize) {
//     var end = (i + batchSize < v.length) ? i + batchSize : v.length;
//     var batchRecords = v.sublist(i, end);
//     await db.transaction((txn) async {
//       var batch = txn.batch();
//       for (var record in batchRecords) {
//         try {
//           batch.insert('POD', record);
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
//       'Time taken for POD_Temp and POD compare : ${stopwatch.elapsedMilliseconds}ms');
//   stopwatch.reset();
//   print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
//   // stopwatch.start();
//   // // await batch3.commit(noResult: true);
//   await db.delete('POD_Temp');
//   // stopwatch.stop();
// }
//
// Future<List<POD>> retrievePOD(BuildContext context) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult = await db.query('POD');
//   return queryResult.map((e) => POD.fromJson(e)).toList();
// }
//
// Future<void> updatePOD(int id, Map<String, dynamic> values,
//     BuildContext context) async {
//   final db = await initializeDB(context);
//   try {
//     db.transaction((db) async {
//       await db.update('POD', values, where: 'ID = ?', whereArgs: [id]);
//     });
//   } catch (e) {
//     writeToLogFile(text: e.toString(),
//         fileName: StackTrace.current.toString(),
//         lineNo: 141);
//     getErrorSnackBar('Sync Error ' + e.toString());
//   }
// }
//
// Future<void> deletePOD(Database db) async {
//   await db.delete('POD');
// }
//
// Future<List<POD>> retrievePODById(BuildContext? context, String str,
//     List l) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//   await db.query('POD', where: str, whereArgs: l);
//   return queryResult.map((e) => POD.fromJson(e)).toList();
// }
//
// Future<void> insertPODToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<POD> list = await retrievePODById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].POId = '';
//     var res = await http.post(Uri.parse(prefix + "POD/Add"),
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
//             .post(Uri.parse(prefix + "POD/Add"),
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
//             var x = await db.update("POD", map,
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
// Future<void> updatePODOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<POD> list = await retrievePODById(
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
//           .put(Uri.parse(prefix + 'POD/Update'),
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
//           var x = await db.update("POD", map,
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
