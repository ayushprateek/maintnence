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
// class PO {
//   String? ID;
//   int? POSerial;
//   double? BillAmount;
//   double? BillPaid;
//   double? Discount;
//   double? Balance;
//   double? PrevBalance;
//   DateTime? Date;
//   bool? PurchaseReturn;
//   int? SupplierId;
//   double? PODId;
//   double? PurchaseOrderAmount;
//   double? PurchaseReturnAmount;
//   double? PurchaseOrderQty;
//   double? PurchaseReturnQty;
//   String? PaymentMethod;
//   String? PaymentDetail;
//   String? Remarks;
//   int? EmployeeId;
//
//   PO({
//     this.ID,
//     this.POSerial,
//     this.BillAmount,
//     this.BillPaid,
//     this.Discount,
//     this.Balance,
//     this.PrevBalance,
//     this.Date,
//     this.PurchaseReturn,
//     this.SupplierId,
//     this.PODId,
//     this.PurchaseOrderAmount,
//     this.PurchaseReturnAmount,
//     this.PurchaseOrderQty,
//     this.PurchaseReturnQty,
//     this.PaymentMethod,
//     this.PaymentDetail,
//     this.Remarks,
//     this.EmployeeId,
//   });
//
//   factory PO.fromJson(Map<String, dynamic> json) =>
//       PO(
//         ID: json['ID'] ?? '',
//         POSerial: int.tryParse(json['POSerial'].toString()) ?? 0,
//         BillAmount: double.tryParse(json['BillAmount'].toString()) ?? 0.0,
//         BillPaid: double.tryParse(json['BillPaid'].toString()) ?? 0.0,
//         Discount: double.tryParse(json['Discount'].toString()) ?? 0.0,
//         Balance: double.tryParse(json['Balance'].toString()) ?? 0.0,
//         PrevBalance: double.tryParse(json['PrevBalance'].toString()) ?? 0.0,
//         Date: DateTime.tryParse(json['Date'].toString()) ??
//             DateTime.parse('1900-01-01'),
//         PurchaseReturn: json['PurchaseReturn'] is bool
//             ? json['PurchaseReturn']
//             : json['PurchaseReturn'] == 1,
//         SupplierId: int.tryParse(json['SupplierId'].toString()) ?? 0,
//         PODId: double.tryParse(json['PODId'].toString()) ?? 0.0,
//         PurchaseOrderAmount:
//         double.tryParse(json['PurchaseOrderAmount'].toString()) ?? 0.0,
//         PurchaseReturnAmount:
//         double.tryParse(json['PurchaseReturnAmount'].toString()) ?? 0.0,
//         PurchaseOrderQty:
//         double.tryParse(json['PurchaseOrderQty'].toString()) ?? 0.0,
//         PurchaseReturnQty:
//         double.tryParse(json['PurchaseReturnQty'].toString()) ?? 0.0,
//         PaymentMethod: json['PaymentMethod'] ?? '',
//         PaymentDetail: json['PaymentDetail'] ?? '',
//         Remarks: json['Remarks'] ?? '',
//         EmployeeId: int.tryParse(json['EmployeeId'].toString()) ?? 0,
//       );
//
//   Map<String, dynamic> toJson() =>
//       {
//         'ID': ID,
//         'POSerial': POSerial,
//         'BillAmount': BillAmount,
//         'BillPaid': BillPaid,
//         'Discount': Discount,
//         'Balance': Balance,
//         'PrevBalance': PrevBalance,
//         'Date': Date?.toIso8601String(),
//         'PurchaseReturn': PurchaseReturn,
//         'SupplierId': SupplierId,
//         'PODId': PODId,
//         'PurchaseOrderAmount': PurchaseOrderAmount,
//         'PurchaseReturnAmount': PurchaseReturnAmount,
//         'PurchaseOrderQty': PurchaseOrderQty,
//         'PurchaseReturnQty': PurchaseReturnQty,
//         'PaymentMethod': PaymentMethod,
//         'PaymentDetail': PaymentDetail,
//         'Remarks': Remarks,
//         'EmployeeId': EmployeeId,
//       };
// }
//
// List<PO> pOFromJson(String str) =>
//     List<PO>.from(json.decode(str).map((x) => PO.fromJson(x)));
//
// String pOToJson(List<PO> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// Future<List<PO>> dataSyncPO() async {
//   var res = await http.get(headers: header, Uri.parse(prefix + "PO" + postfix));
//   print(res.body);
//   return pOFromJson(res.body);
// }
//
// // Future<void> insertPO(Database db, {List? list}) async {
// //   if (postfix.toLowerCase().contains('all')) {
// //     await deletePO(db);
// //   }
// //   List customers;
// //   if (list != null) {
// //     customers = list;
// //   } else {
// //     customers = await dataSyncPO();
// //   }
// //   print(customers);
// //   var batch1 = db.batch();
// //   var batch2 = db.batch();
// //   var batch3 = db.batch();
// //   customers.forEach((customer) async {
// //     print(customer.toJson());
// //     try {
// //       batch1.insert('PO_Temp', customer.toJson());
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
// //       "SELECT * FROM  PO_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
// //   u.forEach((element) {
// //     batch2.update("PO", element,
// //         where: "RowId = ? AND",
// //         whereArgs: [element["RowId"], element["TransId"]]);
// //   });
// //   await batch2.commit(noResult: true);
// //   await batch2.commit(noResult: true);
// //   var v = await db.rawQuery(
// //       "Select * from PO_Temp where TransId || RowId not in (Select TransId || RowId from PO)");
// //   v.forEach((element) {
// //     batch3.insert('PO', element);
// //   });
// //   await batch3.commit(noResult: true);
// //   await db.delete('PO_Temp');
// // }
// Future<void> insertPO(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deletePO(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncPO();
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
//       for (PO record in batchRecords) {
//         try {
//           batch.insert('PO_Temp', record.toJson());
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
// 			select * from PO_Temp
// 			except
// 			select * from PO
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
//           batch.update("PO", element,
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
//   print('Time taken for PO update: ${stopwatch.elapsedMilliseconds}ms');
//   stopwatch.reset();
//   stopwatch.start();
//   var v = await db.rawQuery(
//       "Select * from PO_Temp where TransId || RowId not in (Select TransId || RowId from PO)");
//   for (var i = 0; i < v.length; i += batchSize) {
//     var end = (i + batchSize < v.length) ? i + batchSize : v.length;
//     var batchRecords = v.sublist(i, end);
//     await db.transaction((txn) async {
//       var batch = txn.batch();
//       for (var record in batchRecords) {
//         try {
//           batch.insert('PO', record);
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
//       'Time taken for PO_Temp and PO compare : ${stopwatch.elapsedMilliseconds}ms');
//   stopwatch.reset();
//   print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
//   // stopwatch.start();
//   // // await batch3.commit(noResult: true);
//   await db.delete('PO_Temp');
//   // stopwatch.stop();
// }
//
// Future<List<PO>> retrievePO(BuildContext context) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult = await db.query('PO');
//   return queryResult.map((e) => PO.fromJson(e)).toList();
// }
//
// Future<void> updatePO(int id, Map<String, dynamic> values,
//     BuildContext context) async {
//   final db = await initializeDB(context);
//   try {
//     db.transaction((db) async {
//       await db.update('PO', values, where: 'ID = ?', whereArgs: [id]);
//     });
//   } catch (e) {
//     writeToLogFile(text: e.toString(),
//         fileName: StackTrace.current.toString(),
//         lineNo: 141);
//     getErrorSnackBar('Sync Error ' + e.toString());
//   }
// }
//
// Future<void> deletePO(Database db) async {
//   await db.delete('PO');
// }
//
// Future<List<PO>> retrievePOById(BuildContext? context, String str,
//     List l) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//   await db.query('PO', where: str, whereArgs: l);
//   return queryResult.map((e) => PO.fromJson(e)).toList();
// }
//
// Future<void> insertPOToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<PO> list = await retrievePOById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = '';
//     var res = await http.post(Uri.parse(prefix + "PO/Add"),
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
//             .post(Uri.parse(prefix + "PO/Add"),
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
//             var x = await db.update("PO", map,
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
//   } while (i < list.length && sentSuccessInServer == true);
// }
//
// }
//
// Future<void> updatePOOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<PO> list = await retrievePOById(
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
//           .put(Uri.parse(prefix + 'PO/Update'),
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
//           var x = await db.update("PO", map,
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
