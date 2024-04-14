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
// class Payment {
//   int? ID;
//   String? SOId;
//   String? PaymentMethod;
//   double? PaymentAmount;
//   DateTime? ReceivedDate;
//   String? Remarks;
//   bool? hasCreated;
//   bool? hasUpdated;
//
//   Payment({
//     this.ID,
//     this.SOId,
//     this.PaymentMethod,
//     this.PaymentAmount,
//     this.ReceivedDate,
//     this.Remarks,
//     this.hasCreated,
//     this.hasUpdated,
//   });
//
//   factory Payment.fromJson(Map<String, dynamic> json) =>
//       Payment(
//         ID: int.tryParse(json['ID'].toString()) ?? 0,
//         SOId: json['SOId'] ?? '',
//         PaymentMethod: json['PaymentMethod'] ?? '',
//         PaymentAmount: double.tryParse(json['PaymentAmount'].toString()) ?? 0.0,
//         ReceivedDate: DateTime.tryParse(json['ReceivedDate'].toString()) ??
//             DateTime.parse('1900-01-01'),
//         Remarks: json['Remarks'] ?? '',
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
//         'SOId': SOId,
//         'PaymentMethod': PaymentMethod,
//         'PaymentAmount': PaymentAmount,
//         'ReceivedDate': ReceivedDate?.toIso8601String(),
//         'Remarks': Remarks,
//         'has_created': hasCreated,
//         'has_updated': hasUpdated,
//       };
// }
//
// List<Payment> paymentFromJson(String str) =>
//     List<Payment>.from(json.decode(str).map((x) => Payment.fromJson(x)));
//
// String paymentToJson(List<Payment> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// Future<List<Payment>> dataSyncPayment() async {
//   var res =
//   await http.get(headers: header, Uri.parse(prefix + "Payment" + postfix));
//   print(res.body);
//   return paymentFromJson(res.body);
// }
//
// // Future<void> insertPayment(Database db, {List? list}) async {
// //   if (postfix.toLowerCase().contains('all')) {
// //     await deletePayment(db);
// //   }
// //   List customers;
// //   if (list != null) {
// //     customers = list;
// //   } else {
// //     customers = await dataSyncPayment();
// //   }
// //   print(customers);
// //   var batch1 = db.batch();
// //   var batch2 = db.batch();
// //   var batch3 = db.batch();
// //   customers.forEach((customer) async {
// //     print(customer.toJson());
// //     try {
// //       batch1.insert('Payment_Temp', customer.toJson());
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
// //       "SELECT * FROM  Payment_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
// //   u.forEach((element) {
// //     batch2.update("Payment", element,
// //         where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
// //         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
// //   });
// //   await batch2.commit(noResult: true);
// //   await batch2.commit(noResult: true);
// //   var v = await db.rawQuery(
// //       "Select * from Payment_Temp where TransId || RowId not in (Select TransId || RowId from Payment)");
// //   v.forEach((element) {
// //     batch3.insert('Payment', element);
// //   });
// //   await batch3.commit(noResult: true);
// //   await db.delete('Payment_Temp');
// // }
// Future<void> insertPayment(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deletePayment(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncPayment();
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
//       for (Payment record in batchRecords) {
//         try {
//           batch.insert('Payment_Temp', record.toJson());
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
// 			select * from Payment_Temp
// 			except
// 			select * from Payment
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
//           batch.update("Payment", element,
//               where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//               whereArgs: [element["RowId"], element["TransId"], 1, 1]);
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
//   print('Time taken for Payment update: ${stopwatch.elapsedMilliseconds}ms');
//   stopwatch.reset();
//   stopwatch.start();
//   var v = await db.rawQuery(
//       "Select * from Payment_Temp where TransId || RowId not in (Select TransId || RowId from Payment)");
//   for (var i = 0; i < v.length; i += batchSize) {
//     var end = (i + batchSize < v.length) ? i + batchSize : v.length;
//     var batchRecords = v.sublist(i, end);
//     await db.transaction((txn) async {
//       var batch = txn.batch();
//       for (var record in batchRecords) {
//         try {
//           batch.insert('Payment', record);
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
//       'Time taken for Payment_Temp and Payment compare : ${stopwatch.elapsedMilliseconds}ms');
//   stopwatch.reset();
//   print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
//   // stopwatch.start();
//   // // await batch3.commit(noResult: true);
//   await db.delete('Payment_Temp');
//   // stopwatch.stop();
// }
//
// Future<List<Payment>> retrievePayment(BuildContext context) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult = await db.query('Payment');
//   return queryResult.map((e) => Payment.fromJson(e)).toList();
// }
//
// Future<void> updatePayment(int id, Map<String, dynamic> values,
//     BuildContext context) async {
//   final db = await initializeDB(context);
//   try {
//     db.transaction((db) async {
//       await db.update('Payment', values, where: 'ID = ?', whereArgs: [id]);
//     });
//   } catch (e) {
//     writeToLogFile(text: e.toString(),
//         fileName: StackTrace.current.toString(),
//         lineNo: 141);
//     getErrorSnackBar('Sync Error ' + e.toString());
//   }
// }
//
// Future<void> deletePayment(Database db) async {
//   await db.delete('Payment');
// }
//
// Future<List<Payment>> retrievePaymentById(BuildContext? context, String str,
//     List l) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//   await db.query('Payment', where: str, whereArgs: l);
//   return queryResult.map((e) => Payment.fromJson(e)).toList();
// }
//
// Future<void> insertPaymentToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<Payment> list = await retrievePaymentById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "Payment/Add"),
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
//             .post(Uri.parse(prefix + "Payment/Add"),
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
//             var x = await db.update("Payment", map,
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
// Future<void> updatePaymentOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<Payment> list = await retrievePaymentById(
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
//           .put(Uri.parse(prefix + 'Payment/Update'),
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
//           var x = await db.update("Payment", map,
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
