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
// class Product {
//   int? ID;
//   String? Name;
//   double? PurchasePrice;
//   double? SalePrice;
//   double? Stock;
//   int? PerPack;
//   double? totalPiece;
//   bool? Saleable;
//   String? RackPosition;
//   int? SupplierId;
//   String? Attachment;
//   String? Remarks;
//   String? BarCode;
//   int? ReOrder;
//   int? LocationId;
//   DateTime? CreateDate;
//   DateTime? UpdateDate;
//
//   Product({
//     this.ID,
//     this.Name,
//     this.PurchasePrice,
//     this.SalePrice,
//     this.Stock,
//     this.PerPack,
//     this.totalPiece,
//     this.Saleable,
//     this.RackPosition,
//     this.SupplierId,
//     this.Attachment,
//     this.Remarks,
//     this.BarCode,
//     this.ReOrder,
//     this.LocationId,
//     this.CreateDate,
//     this.UpdateDate,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) =>
//       Product(
//         ID: int.tryParse(json['ID'].toString()) ?? 0,
//         Name: json['Name'] ?? '',
//         PurchasePrice: double.tryParse(json['PurchasePrice'].toString()) ?? 0.0,
//         SalePrice: double.tryParse(json['SalePrice'].toString()) ?? 0.0,
//         Stock: double.tryParse(json['Stock'].toString()) ?? 0.0,
//         PerPack: int.tryParse(json['PerPack'].toString()) ?? 0,
//         totalPiece: double.tryParse(json['totalPiece'].toString()) ?? 0.0,
//         Saleable:
//         json['Saleable'] is bool ? json['Saleable'] : json['Saleable'] == 1,
//         RackPosition: json['RackPosition'] ?? '',
//         SupplierId: int.tryParse(json['SupplierId'].toString()) ?? 0,
//         Attachment: json['Attachment'] ?? '',
//         Remarks: json['Remarks'] ?? '',
//         BarCode: json['BarCode'] ?? '',
//         ReOrder: int.tryParse(json['ReOrder'].toString()) ?? 0,
//         LocationId: int.tryParse(json['LocationId'].toString()) ?? 0,
//         CreateDate: DateTime.tryParse(json['CreateDate'].toString()) ??
//             DateTime.parse('1900-01-01'),
//         UpdateDate: DateTime.tryParse(json['UpdateDate'].toString()) ??
//             DateTime.parse('1900-01-01'),
//       );
//
//   Map<String, dynamic> toJson() =>
//       {
//         'ID': ID,
//         'Name': Name,
//         'PurchasePrice': PurchasePrice,
//         'SalePrice': SalePrice,
//         'Stock': Stock,
//         'PerPack': PerPack,
//         'totalPiece': totalPiece,
//         'Saleable': Saleable,
//         'RackPosition': RackPosition,
//         'SupplierId': SupplierId,
//         'Attachment': Attachment,
//         'Remarks': Remarks,
//         'BarCode': BarCode,
//         'ReOrder': ReOrder,
//         'LocationId': LocationId,
//         'CreateDate': CreateDate?.toIso8601String(),
//         'UpdateDate': UpdateDate?.toIso8601String(),
//       };
// }
//
// List<Product> productFromJson(String str) =>
//     List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));
//
// String productToJson(List<Product> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// Future<List<Product>> dataSyncProduct() async {
//   var res =
//   await http.get(headers: header, Uri.parse(prefix + "Product" + postfix));
//   print(res.body);
//   return productFromJson(res.body);
// }
//
// Future<void> insertProduct(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteProduct(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncProduct();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('Product_Temp', customer.toJson());
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
//       "SELECT * FROM  Product_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("Product", element,
//         where: "RowId = ? AND TransId = ?",
//         whereArgs: [element["RowId"], element["TransId"]]);
//   });
//   await batch2.commit(noResult: true);
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from Product_Temp where TransId || RowId not in (Select TransId || RowId from Product)");
//   v.forEach((element) {
//     batch3.insert('Product', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('Product_Temp');
// }
//
// Future<List<Product>> retrieveProduct(BuildContext context) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult = await db.query('Product');
//   return queryResult.map((e) => Product.fromJson(e)).toList();
// }
//
// Future<void> updateProduct(int id, Map<String, dynamic> values,
//     BuildContext context) async {
//   final db = await initializeDB(context);
//   try {
//     db.transaction((db) async {
//       await db.update('Product', values, where: 'ID = ?', whereArgs: [id]);
//     });
//   } catch (e) {
//     writeToLogFile(text: e.toString(),
//         fileName: StackTrace.current.toString(),
//         lineNo: 141);
//     getErrorSnackBar('Sync Error ' + e.toString());
//   }
// }
//
// Future<void> deleteProduct(Database db) async {
//   await db.delete('Product');
// }
//
// Future<List<Product>> retrieveProductById(BuildContext? context, String str,
//     List l) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//   await db.query('Product', where: str, whereArgs: l);
//   return queryResult.map((e) => Product.fromJson(e)).toList();
// }
//
// Future<void> insertProductToServer(BuildContext? context,
//     {String? TransId, int? id}) async {
//   String response = "";
//   List<Product> list = await retrieveProductById(
//       context,
//       TransId == null
//           ? DataSync.getInsertToServerStr()
//           : "TransId = ? AND ID = ?",
//       TransId == null ? DataSync.getInsertToServerList() : [TransId, id]);
//   if (TransId != null) {
//     list[0].ID = 0;
//     var res = await http.post(Uri.parse(prefix + "Product/Add"),
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
//             .post(Uri.parse(prefix + "Product/Add"),
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
//             var x = await db.update("Product", map,
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
// Future<void> updateProductOnServer(BuildContext? context,
//     {String? condition, List? l}) async {
//   List<Product> list = await retrieveProductById(
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
//           .put(Uri.parse(prefix + 'Product/Update'),
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
//           var x = await db.update("Product", map,
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
