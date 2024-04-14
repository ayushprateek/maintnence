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
// class ProductionOrderDetail {
//   double? Auto;
//   String? SOId;
//   int? SODId;
//   int? ProductId;
//   int? Quantity;
//   double? SalePrice;
//   double? PurchasePrice;
//   bool? SaleType;
//   int? ShortFall;
//   int? Remarks;
//
//   ProductionOrderDetail({
//     this.Auto,
//     this.SOId,
//     this.SODId,
//     this.ProductId,
//     this.Quantity,
//     this.SalePrice,
//     this.PurchasePrice,
//     this.SaleType,
//     this.ShortFall,
//     this.Remarks,
//   });
//
//   factory ProductionOrderDetail.fromJson(Map<String, dynamic> json) =>
//       ProductionOrderDetail(
//         Auto: double.tryParse(json['Auto'].toString()) ?? 0.0,
//         SOId: json['SOId'] ?? '',
//         SODId: int.tryParse(json['SODId'].toString()) ?? 0,
//         ProductId: int.tryParse(json['ProductId'].toString()) ?? 0,
//         Quantity: int.tryParse(json['Quantity'].toString()) ?? 0,
//         SalePrice: double.tryParse(json['SalePrice'].toString()) ?? 0.0,
//         PurchasePrice: double.tryParse(json['PurchasePrice'].toString()) ?? 0.0,
//         SaleType:
//         json['SaleType'] is bool ? json['SaleType'] : json['SaleType'] == 1,
//         ShortFall: int.tryParse(json['ShortFall'].toString()) ?? 0,
//         Remarks: int.tryParse(json['Remarks'].toString()) ?? 0,
//       );
//
//   Map<String, dynamic> toJson() =>
//       {
//         'Auto': Auto,
//         'SOId': SOId,
//         'SODId': SODId,
//         'ProductId': ProductId,
//         'Quantity': Quantity,
//         'SalePrice': SalePrice,
//         'PurchasePrice': PurchasePrice,
//         'SaleType': SaleType,
//         'ShortFall': ShortFall,
//         'Remarks': Remarks,
//       };
// }
//
// List<ProductionOrderDetail> productionOrderDetailFromJson(String str) =>
//     List<ProductionOrderDetail>.from(
//         json.decode(str).map((x) => ProductionOrderDetail.fromJson(x)));
//
// String productionOrderDetailToJson(List<ProductionOrderDetail> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// Future<List<ProductionOrderDetail>> dataSyncProductionOrderDetail() async {
//   var res = await http.get(
//       headers: header, Uri.parse(prefix + "ProductionOrderDetail" + postfix));
//   print(res.body);
//   return productionOrderDetailFromJson(res.body);
// }
//
// Future<void> insertProductionOrderDetail(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteProductionOrderDetail(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncProductionOrderDetail();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('ProductionOrderDetail_Temp', customer.toJson());
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
//       "SELECT * FROM  ProductionOrderDetail_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("ProductionOrderDetail", element,
//         where: "RowId = ? AND TransId = ?",
//         whereArgs: [element["RowId"], element["TransId"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from ProductionOrderDetail_Temp where TransId || RowId not in (Select TransId || RowId from ProductionOrderDetail)");
//   v.forEach((element) {
//     batch3.insert('ProductionOrderDetail', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('ProductionOrderDetail_Temp');
// }
//
// Future<List<ProductionOrderDetail>> retrieveProductionOrderDetail(
//     BuildContext context) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//   await db.query('ProductionOrderDetail');
//   return queryResult.map((e) => ProductionOrderDetail.fromJson(e)).toList();
// }
//
// Future<void> updateProductionOrderDetail(int id, Map<String, dynamic> values,
//     BuildContext context) async {
//   final db = await initializeDB(context);
//   try {
//     db.transaction((db) async {
//       await db.update('ProductionOrderDetail', values,
//           where: 'ID = ?', whereArgs: [id]);
//     });
//   } catch (e) {
//     writeToLogFile(text: e.toString(),
//         fileName: StackTrace.current.toString(),
//         lineNo: 141);
//     getErrorSnackBar('Sync Error ' + e.toString());
//   }
// }
//
// Future<void> deleteProductionOrderDetail(Database db) async {
//   await db.delete('ProductionOrderDetail');
// }
//
// Future<List<ProductionOrderDetail>> retrieveProductionOrderDetailById(
//     BuildContext? context, String str, List l) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//   await db.query('ProductionOrderDetail', where: str, whereArgs: l);
//   return queryResult.map((e) => ProductionOrderDetail.fromJson(e)).toList();
// }
//
// Future<void> insertProductionOrderDetailToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<ProductionOrderDetail> list = await retrieveProductionOrderDetailById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].SOId = '';
//     var res = await http.post(Uri.parse(prefix + "ProductionOrderDetail/Add"),
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
//             .post(Uri.parse(prefix + "ProductionOrderDetail/Add"),
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
//             var x = await db.update("ProductionOrderDetail", map,
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
// Future<void> updateProductionOrderDetailOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<ProductionOrderDetail> list = await retrieveProductionOrderDetailById(
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
//           .put(Uri.parse(prefix + 'ProductionOrderDetail/Update'),
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
//           var x = await db.update("ProductionOrderDetail", map,
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
