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
// class ProductionOrder {
//   String? ID;
//   int? SOSerial;
//   double? BillAmount;
//   double? BillPaid;
//   double? Discount;
//   double? Balance;
//   double? PrevBalance;
//   DateTime? Date;
//   bool? SaleReturn;
//   double? SODId;
//   double? SaleOrderAmount;
//   double? SaleReturnAmount;
//   int? SaleOrderQty;
//   int? SaleReturnQty;
//   double? Profit;
//   String? Remarks;
//   String? ProductionOrderName;
//   DateTime? StartDate;
//   DateTime? EndDate;
//   int? ProductionOrderQty;
//   int? EmployeeId;
//
//   ProductionOrder({
//     this.ID,
//     this.SOSerial,
//     this.BillAmount,
//     this.BillPaid,
//     this.Discount,
//     this.Balance,
//     this.PrevBalance,
//     this.Date,
//     this.SaleReturn,
//     this.SODId,
//     this.SaleOrderAmount,
//     this.SaleReturnAmount,
//     this.SaleOrderQty,
//     this.SaleReturnQty,
//     this.Profit,
//     this.Remarks,
//     this.ProductionOrderName,
//     this.StartDate,
//     this.EndDate,
//     this.ProductionOrderQty,
//     this.EmployeeId,
//   });
//
//   factory ProductionOrder.fromJson(Map<String, dynamic> json) =>
//       ProductionOrder(
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
//         SODId: double.tryParse(json['SODId'].toString()) ?? 0.0,
//         SaleOrderAmount:
//         double.tryParse(json['SaleOrderAmount'].toString()) ?? 0.0,
//         SaleReturnAmount:
//         double.tryParse(json['SaleReturnAmount'].toString()) ?? 0.0,
//         SaleOrderQty: int.tryParse(json['SaleOrderQty'].toString()) ?? 0,
//         SaleReturnQty: int.tryParse(json['SaleReturnQty'].toString()) ?? 0,
//         Profit: double.tryParse(json['Profit'].toString()) ?? 0.0,
//         Remarks: json['Remarks'] ?? '',
//         ProductionOrderName: json['ProductionOrderName'] ?? '',
//         StartDate: DateTime.tryParse(json['StartDate'].toString()) ??
//             DateTime.parse('1900-01-01'),
//         EndDate: DateTime.tryParse(json['EndDate'].toString()) ??
//             DateTime.parse('1900-01-01'),
//         ProductionOrderQty:
//         int.tryParse(json['ProductionOrderQty'].toString()) ?? 0,
//         EmployeeId: int.tryParse(json['EmployeeId'].toString()) ?? 0,
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
//         'SODId': SODId,
//         'SaleOrderAmount': SaleOrderAmount,
//         'SaleReturnAmount': SaleReturnAmount,
//         'SaleOrderQty': SaleOrderQty,
//         'SaleReturnQty': SaleReturnQty,
//         'Profit': Profit,
//         'Remarks': Remarks,
//         'ProductionOrderName': ProductionOrderName,
//         'StartDate': StartDate?.toIso8601String(),
//         'EndDate': EndDate?.toIso8601String(),
//         'ProductionOrderQty': ProductionOrderQty,
//         'EmployeeId': EmployeeId,
//       };
// }
//
// List<ProductionOrder> productionOrderFromJson(String str) =>
//     List<ProductionOrder>.from(
//         json.decode(str).map((x) => ProductionOrder.fromJson(x)));
//
// String productionOrderToJson(List<ProductionOrder> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// Future<List<ProductionOrder>> dataSyncProductionOrder() async {
//   var res = await http.get(
//       headers: header, Uri.parse(prefix + "ProductionOrder" + postfix));
//   print(res.body);
//   return productionOrderFromJson(res.body);
// }
//
// Future<void> insertProductionOrder(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteProductionOrder(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncProductionOrder();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ProductionOrder_Temp', customer.toJson());
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
//       "SELECT * FROM  ProductionOrder_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("ProductionOrder", element,
//         where: "RowId = ? AND TransId = ?",
//         whereArgs: [element["RowId"], element["TransId"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from ProductionOrder_Temp where TransId || RowId not in (Select TransId || RowId from ProductionOrder)");
//   v.forEach((element) {
//     batch3.insert('ProductionOrder', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ProductionOrder_Temp');
// }
//
// Future<List<ProductionOrder>> retrieveProductionOrder(
//     BuildContext context) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//   await db.query('ProductionOrder');
//   return queryResult.map((e) => ProductionOrder.fromJson(e)).toList();
// }
//
// Future<void> updateProductionOrder(int id, Map<String, dynamic> values,
//     BuildContext context) async {
//   final db = await initializeDB(context);
//   try {
//     db.transaction((db) async {
//       await db
//           .update('ProductionOrder', values, where: 'ID = ?', whereArgs: [id]);
//     });
//   } catch (e) {
//     writeToLogFile(text: e.toString(),
//         fileName: StackTrace.current.toString(),
//         lineNo: 141);
//     getErrorSnackBar('Sync Error ' + e.toString());
//   }
// }
//
// Future<void> deleteProductionOrder(Database db) async {
//   await db.delete('ProductionOrder');
// }
//
// Future<List<ProductionOrder>> retrieveProductionOrderById(BuildContext? context,
//     String str, List l) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//   await db.query('ProductionOrder', where: str, whereArgs: l);
//   return queryResult.map((e) => ProductionOrder.fromJson(e)).toList();
// }
//
// Future<void> insertProductionOrderToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<ProductionOrder> list = await retrieveProductionOrderById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = '';
//     var res = await http.post(Uri.parse(prefix + "ProductionOrder/Add"),
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
//             .post(Uri.parse(prefix + "ProductionOrder/Add"),
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
//             var x = await db.update("ProductionOrder", map,
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
// Future<void> updateProductionOrderOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<ProductionOrder> list = await retrieveProductionOrderById(
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
//           .put(Uri.parse(prefix + 'ProductionOrder/Update'),
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
//           var x = await db.update("ProductionOrder", map,
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
