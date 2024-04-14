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
// class SO {
//   String? ID;
//   int? SOSerial;
//   double? BillAmount;
//   double? BillPaid;
//   double? Discount;
//   double? Balance;
//   double? PrevBalance;
//   DateTime? Date;
//   bool? SaleReturn;
//   int? CustomerId;
//   double? SODId;
//   double? SaleOrderAmount;
//   double? SaleReturnAmount;
//   double? SaleOrderQty;
//   double? SaleReturnQty;
//   double? Profit;
//   String? PaymentMethod;
//   String? PaymentDetail;
//   String? Remarks;
//   int? EmployeeId;
//   int? hasCreated;
//   int? hasUpdated;
//
//   SO({
//     this.ID,
//     this.SOSerial,
//     this.BillAmount,
//     this.BillPaid,
//     this.Discount,
//     this.Balance,
//     this.PrevBalance,
//     this.Date,
//     this.SaleReturn,
//     this.CustomerId,
//     this.SODId,
//     this.SaleOrderAmount,
//     this.SaleReturnAmount,
//     this.SaleOrderQty,
//     this.SaleReturnQty,
//     this.Profit,
//     this.PaymentMethod,
//     this.PaymentDetail,
//     this.Remarks,
//     this.EmployeeId,
//     this.hasCreated,
//     this.hasUpdated,
//   });
//
//   factory SO.fromJson(Map<String, dynamic> json) =>
//       SO(
//         ID: json['ID'] ?? '',
//         SOSerial: int.tryParse(json['SOSerial'].toString()) ?? 0,
//         BillAmount: double.tryParse(json['BillAmount'].toString()) ?? 0.0,
//         BillPaid: double.tryParse(json['BillPaid'].toString()) ?? 0.0,
//         Discount: double.tryParse(json['Discount'].toString()) ?? 0.0,
//         Balance: double.tryParse(json['Balance'].toString()) ?? 0.0,
//         PrevBalance: double.tryParse(json['PrevBalance'].toString()) ?? 0.0,
//         Date: DateTime.tryParse(json['Date'].toString()) ??
//             DateTime.parse('1900-01-01'),
//         SaleReturn: json['SaleReturn'] is bool
//             ? json['SaleReturn']
//             : json['SaleReturn'] == 1,
//         CustomerId: int.tryParse(json['CustomerId'].toString()) ?? 0,
//         SODId: double.tryParse(json['SODId'].toString()) ?? 0.0,
//         SaleOrderAmount:
//         double.tryParse(json['SaleOrderAmount'].toString()) ?? 0.0,
//         SaleReturnAmount:
//         double.tryParse(json['SaleReturnAmount'].toString()) ?? 0.0,
//         SaleOrderQty: double.tryParse(json['SaleOrderQty'].toString()) ?? 0.0,
//         SaleReturnQty: double.tryParse(json['SaleReturnQty'].toString()) ?? 0.0,
//         Profit: double.tryParse(json['Profit'].toString()) ?? 0.0,
//         PaymentMethod: json['PaymentMethod'] ?? '',
//         PaymentDetail: json['PaymentDetail'] ?? '',
//         Remarks: json['Remarks'] ?? '',
//         EmployeeId: int.tryParse(json['EmployeeId'].toString()) ?? 0,
//         hasCreated: int.tryParse(json['has_created'].toString()) ?? 0,
//         hasUpdated: int.tryParse(json['has_updated'].toString()) ?? 0,
//       );
//
//   Map<String, dynamic> toJson() =>
//       {
//         'ID': ID,
//         'SOSerial': SOSerial,
//         'BillAmount': BillAmount,
//         'BillPaid': BillPaid,
//         'Discount': Discount,
//         'Balance': Balance,
//         'PrevBalance': PrevBalance,
//         'Date': Date?.toIso8601String(),
//         'SaleReturn': SaleReturn,
//         'CustomerId': CustomerId,
//         'SODId': SODId,
//         'SaleOrderAmount': SaleOrderAmount,
//         'SaleReturnAmount': SaleReturnAmount,
//         'SaleOrderQty': SaleOrderQty,
//         'SaleReturnQty': SaleReturnQty,
//         'Profit': Profit,
//         'PaymentMethod': PaymentMethod,
//         'PaymentDetail': PaymentDetail,
//         'Remarks': Remarks,
//         'EmployeeId': EmployeeId,
//         'has_created': hasCreated,
//         'has_updated': hasUpdated,
//       };
// }
//
// List<SO> sOFromJson(String str) =>
//     List<SO>.from(json.decode(str).map((x) => SO.fromJson(x)));
//
// String sOToJson(List<SO> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// Future<List<SO>> dataSyncSO() async {
//   var res = await http.get(headers: header, Uri.parse(prefix + "SO" + postfix));
//   print(res.body);
//   return sOFromJson(res.body);
// }
//
// Future<void> insertSO(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSO(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSO();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('SO_Temp', customer.toJson());
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
//       "SELECT * FROM  SO_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("SO", element,
//         where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from SO_Temp where TransId || RowId not in (Select TransId || RowId from SO)");
//   v.forEach((element) {
//     batch3.insert('SO', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('SO_Temp');
// }
//
// Future<List<SO>> retrieveSO(BuildContext context) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult = await db.query('SO');
//   return queryResult.map((e) => SO.fromJson(e)).toList();
// }
//
// Future<void> updateSO(int id, Map<String, dynamic> values,
//     BuildContext context) async {
//   final db = await initializeDB(context);
//   try {
//     db.transaction((db) async {
//       await db.update('SO', values, where: 'ID = ?', whereArgs: [id]);
//     });
//   } catch (e) {
//     writeToLogFile(text: e.toString(),
//         fileName: StackTrace.current.toString(),
//         lineNo: 141);
//     getErrorSnackBar('Sync Error ' + e.toString());
//   }
// }
//
// Future<void> deleteSO(Database db) async {
//   await db.delete('SO');
// }
//
// Future<List<SO>> retrieveSOById(BuildContext? context, String str,
//     List l) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//   await db.query('SO', where: str, whereArgs: l);
//   return queryResult.map((e) => SO.fromJson(e)).toList();
// }
//
// Future<void> insertSOToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<SO> list = await retrieveSOById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = '';
//     var res = await http.post(Uri.parse(prefix + "SO/Add"),
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
//             .post(Uri.parse(prefix + "SO/Add"),
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
//             var x = await db.update("SO", map,
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
// Future<void> updateSOOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<SO> list = await retrieveSOById(
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
//           .put(Uri.parse(prefix + 'SO/Update'),
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
//           var x = await db.update("SO", map,
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
