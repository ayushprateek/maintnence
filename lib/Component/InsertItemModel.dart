import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:sqflite/sqlite_api.dart';

class InsertItemModel {
  bool insertedIntoDatabase = false;
  int ID, RowId;
  String ItemCode,
      ItemName,
      UOM,
      TransId,
      TaxCode,
      BaseTransId,
      BaseRowId,
      LineStatus,
      DSTranId;
  String? BaseType;
  double Quantity, TaxRate, Price, Discount, Linetotal, MSP, OpenQuantity;

  InsertItemModel({
    required this.ID,
    required this.ItemName,
    required this.ItemCode,
    required this.UOM,
    required this.insertedIntoDatabase,
    required this.MSP,
    required this.Quantity,
    required this.TaxRate,
    required this.TransId,
    required this.Linetotal,
    required this.Discount,
    required this.TaxCode,
    required this.Price,
    required this.BaseRowId,
    required this.BaseTransId,
    required this.LineStatus,
    required this.OpenQuantity,
    required this.DSTranId,
    this.BaseType,
    required this.RowId,
  });

  InsertItemModel.fromMap(Map<String, dynamic> res)
      : ID = res["ID"] ?? 0,
        RowId = int.tryParse(res["RowId"].toString()) ?? 0,
        MSP = double.tryParse(res["MSP"].toString()) ?? 0.0,
        OpenQuantity = double.tryParse(res["OpenQuantity"].toString()) ?? 0.0,
        BaseTransId = res["BaseTransId"] ?? "",
        BaseRowId =
            res["BaseRowId"] == null ? "0.0" : res["BaseRowId"].toString(),
        Price = double.tryParse(res["Price"].toString()) ?? 0.0,
        TaxCode = res["TaxCode"] ?? "",
        Discount = getDouble(res["Discount"].toString()),
        Linetotal = getDouble(res["Linetotal"].toString()),
        TransId = res["TransId"] ?? "",
        LineStatus = res["LineStatus"] ?? "",
        BaseType = res["BaseType"] ?? "",
        DSTranId = res["DSTranId"] ?? "",
        ItemName = res["ItemName"] ?? "",
        UOM = res["UOM"] ?? "",
        Quantity = getDouble(res["Quantity"].toString()),
        TaxRate = getDouble(res["TaxRate"].toString()),
        ItemCode = res["ItemCode"] ?? "";

  static double getDouble(String str) {
    double d = 0.0;
    try {
      d = double.parse(str);
    } catch (e) {
      writeToLogFile(
          text: e.toString(), fileName: StackTrace.current.toString(), lineNo: 141);
    }
    return d;
  }

  Map<String, Object> toMap() {
    return {
      'ID': ID,
      'UOM': UOM,
      'BaseType': BaseType ?? "",
      'Quantity': Quantity,
      'LineStatus': LineStatus,
      'TaxRate': TaxRate,
      'MSP': double.tryParse(MSP.toString()) ?? 0.0,
      'ItemCode': ItemCode,
      'OpenQuantity': OpenQuantity,
      'ItemName': ItemName,
      'BaseTransId': BaseTransId,
      'BaseRowId': BaseRowId,
      'Price': Price,
      'Discount': Discount,
      'Linetotal': Linetotal,
      'TaxCode': TaxCode,
      'DSTranId': DSTranId,
      'TransId': TransId,
    };
  }
}

Future<void> updateCartItem(Map<String, dynamic> values, int item_code,
    String DBName, BuildContext context) async {
  final db = await initializeDB(context);
  await db
      .update(DBName, values, where: 'item_code = ?', whereArgs: [item_code]);
}

Future<int> insertCartItem(
    InsertItemModel itemModel, String DBName, BuildContext context) async {
  List<InsertItemModel> listOfItems = [itemModel];
  int result = 0;
  final Database db = await initializeDB(context);
  for (var item in listOfItems) {
    var itemMap = item.toMap();
    itemMap["has_created"] = 1;
    result = await db.insert(DBName, itemMap);
  }
  return result;
}

Future<List<InsertItemModel>> retrieveAddedItems(
    String DBName, String TransId, BuildContext context,
    {var database}) async {
  var db;
  if (database != null) {
    db = database;
  } else {
    db = await initializeDB(context);
  }
  final List<Map<String, Object?>> queryResult =
      await db.query(DBName, where: "TransId = ? ", whereArgs: [TransId]) ??
          [{}];
  return queryResult.map((e) => InsertItemModel.fromMap(e)).toList();
}

// Future<List<InsertItemModel>> RetrieveAddedItems(
//     String DBName, String str, String MTransId, BuildContext context) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//       await db.query(DBName, where: str, whereArgs: [MTransId]);
//   return queryResult.map((e) => InsertItemModel.fromMap(e)).toList();
// }

// Future<List<InsertItemModel>> retrieveAddedItemsDSC(
//     String DBName, String MTransId, BuildContext context) async {
//   final Database db = await initializeDB(context);
//   final List<Map<String, Object?>> queryResult =
//       await db.query(DBName, where: "TransId = ? ", whereArgs: [MTransId]);
//   return queryResult.map((e) => InsertItemModel.fromMap(e)).toList();
// }
