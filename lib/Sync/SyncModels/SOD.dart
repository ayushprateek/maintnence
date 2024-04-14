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
// class SOD {
//   double? Auto;
//   String? SOId;
//   int? SODId;
//   int? ProductId;
//   double? OpeningStock;
//   int? Quantity;
//   double? SalePrice;
//   double? PurchasePrice;
//   double? PerPack;
//   bool? IsPack;
//   bool? SaleType;
//   double? Profit;
//   String? Remarks;
//   int? hasCreated;
//   int? hasUpdated;
//
//   SOD({
//     this.Auto,
//     this.SOId,
//     this.SODId,
//     this.ProductId,
//     this.OpeningStock,
//     this.Quantity,
//     this.SalePrice,
//     this.PurchasePrice,
//     this.PerPack,
//     this.IsPack,
//     this.SaleType,
//     this.Profit,
//     this.Remarks,
//     this.hasCreated,
//     this.hasUpdated,
//   });
//
//   factory SOD.fromJson(Map<String, dynamic> json) =>
//       SOD(
//         Auto: double.tryParse(json['Auto'].toString()) ?? 0.0,
//         SOId: json['SOId'] ?? '',
//         SODId: int.tryParse(json['SODId'].toString()) ?? 0,
//         ProductId: int.tryParse(json['ProductId'].toString()) ?? 0,
//         OpeningStock: double.tryParse(json['OpeningStock'].toString()) ?? 0.0,
//         Quantity: int.tryParse(json['Quantity'].toString()) ?? 0,
//         SalePrice: double.tryParse(json['SalePrice'].toString()) ?? 0.0,
//         PurchasePrice: double.tryParse(json['PurchasePrice'].toString()) ?? 0.0,
//         PerPack: double.tryParse(json['PerPack'].toString()) ?? 0.0,
//         IsPack: json['IsPack'] is bool ? json['IsPack'] : json['IsPack'] == 1,
//         SaleType:
//         json['SaleType'] is bool ? json['SaleType'] : json['SaleType'] == 1,
//         Profit: double.tryParse(json['Profit'].toString()) ?? 0.0,
//         Remarks: json['Remarks'] ?? '',
//         hasCreated: int.tryParse(json['has_created'].toString()) ?? 0,
//         hasUpdated: int.tryParse(json['has_updated'].toString()) ?? 0,
//       );
//
//   Map<String, dynamic> toJson() =>
//       {
//         'Auto': Auto,
//         'SOId': SOId,
//         'SODId': SODId,
//         'ProductId': ProductId,
//         'OpeningStock': OpeningStock,
//         'Quantity': Quantity,
//         'SalePrice': SalePrice,
//         'PurchasePrice': PurchasePrice,
//         'PerPack': PerPack,
//         'IsPack': IsPack,
//         'SaleType': SaleType,
//         'Profit': Profit,
//         'Remarks': Remarks,
//         'has_created': hasCreated,
//         'has_updated': hasUpdated,
//       };
// }
//
// List<SOD> sODFromJson(String str) =>
//     List<SOD>.from(json.decode(str).map((x) => SOD.fromJson(x)));
//
// String sODToJson(List<SOD> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// Future<List<SOD>> dataSyncSOD() async {
//   var res =
//   await http.get(headers: header, Uri.parse(prefix + "SOD" + postfix));
//   print(res.body);
//   return sODFromJson(res.body);
// }
//
// Future<void> insertSOD(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteSOD(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncSOD();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('SOD_Temp', customer.toJson());
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
//       "SELECT * FROM  SOD_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("SOD", element,
//         where: "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from SOD_Temp where TransId || RowId not in (Select TransId || RowId from SOD)");
//   v.forEach((element) {
//     batch3.insert('SOD', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('SOD_Temp');
// }
//
// Future<List<SOD>> retrieveSOD(BuildContext context) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult = await db.query('SOD');
//   return queryResult.map((e) => SOD.fromJson(e)).toList();
// }
//
// Future<void> updateSOD(int id, Map<String, dynamic> values,
//     BuildContext context) async {
//   final db = await initializeDB(context);
//   try {
//     db.transaction((db) async {
//       await db.update('SOD', values, where: 'ID = ?', whereArgs: [id]);
//     });
//   } catch (e) {
//     writeToLogFile(text: e.toString(),
//         fileName: StackTrace.current.toString(),
//         lineNo: 141);
//     getErrorSnackBar('Sync Error ' + e.toString());
//   }
// }
//
// Future<void> deleteSOD(Database db) async {
//   await db.delete('SOD');
// }
//
// Future<List<SOD>> retrieveSODById(BuildContext? context, String str,
//     List l) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//   await db.query('SOD', where: str, whereArgs: l);
//   return queryResult.map((e) => SOD.fromJson(e)).toList();
// }
//
// Future<void> insertSODToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<SOD> list = await retrieveSODById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].SOId = '';
//     var res = await http.post(Uri.parse(prefix + "SOD/Add"),
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
//             .post(Uri.parse(prefix + "SOD/Add"),
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
//             var x = await db.update("SOD", map,
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
// Future<void> updateSODOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<SOD> list = await retrieveSODById(
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
//           .put(Uri.parse(prefix + 'SOD/Update'),
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
//           var x = await db.update("SOD", map,
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
