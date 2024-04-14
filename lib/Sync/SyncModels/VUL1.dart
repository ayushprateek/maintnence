import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<VUL1Model> VUL1ModelFromJson(String str) =>
    List<VUL1Model>.from(json.decode(str).map((x) => VUL1Model.fromJson(x)));

String VUL1ModelToJson(List<VUL1Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VUL1Model {
  VUL1Model({
    required this.ID,
    required this.RowId,
    required this.TransId,
    required this.ItemCode,
    required this.ItemName,
    required this.Quantity,
    required this.OpenQty,
    required this.UOM,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
  });

  int ID;
  int RowId;

  String TransId;
  String ItemCode;
  String ItemName;
  double Quantity;
  double OpenQty;
  String UOM;

  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;

  factory VUL1Model.fromJson(Map<String, dynamic> json) => VUL1Model(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        RowId: int.tryParse(json["RowId"].toString()) ?? 0,
        TransId: json["TransId"] ?? "",
        ItemCode: json["ItemCode"] ?? "",
        ItemName: json["ItemName"] ?? "",
        OpenQty: double.tryParse(json["OpenQty"].toString()) ?? 0.0,
        Quantity: double.tryParse(json["Quantity"].toString()) ?? 0.0,
        UOM: json["UOM"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "RowId": RowId,
        "OpenQty": OpenQty,
        "TransId": TransId,
        "ItemCode": ItemCode,
        "ItemName": ItemName,
        "Quantity": Quantity,
        "UOM": UOM,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
      };
}

Future<List<VUL1Model>> dataSyncVUL1() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "VUL1" + postfix));
  print(res.body);
  return VUL1ModelFromJson(res.body);
}

Future<List<VUL1Model>> retrieveVUL1(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('VUL1');
  return queryResult.map((e) => VUL1Model.fromJson(e)).toList();
}

Future<void> updateVUL1(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("VUL1", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteVUL1(Database db) async {
  await db.delete('VUL1');
}

// Future<void> insertVUL1(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteVUL1(db);
//   List customers= await dataSyncVUL1();
//   print(customers);
//
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('VUL1', customer.toJson());
//     }
//     catch(e)
//     {
//       getErrorSnackBar("Sync Error "+e.toString());
//     }
//   });
//   await batch.commit(noResult: true);
//
//   // customers.forEach((customer) async {
//   //   print(customer.toJson());
//   //   try
//   //   {
//   //     db.transaction((db)async{
//   //       await db.insert('VUL1', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
//
// }
// Future<void> insertVUL1(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteVUL1(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncVUL1();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('VUL1_Temp', customer.toJson());
//     } catch (e) {
//       writeToLogFile(
//           text: e.toString(),
//           fileName: StackTrace.current.toString(),
//           lineNo: 141);
//       getErrorSnackBar("Sync Error " + e.toString());
//     }
//   });
//   await batch1.commit(noResult: true);
//   var u = await db.rawQuery(
//       "SELECT * FROM  VUL1_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN updateDate IS NULL THEN createDate ELSE updateDate END)");
//   u.forEach((element) {
//     batch2.update("VUL1", element,
//         where:
//             "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["RowId"], element["TransId"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from VUL1_Temp where TransId || RowId not in (Select TransId || RowId from VUL1)");
//   v.forEach((element) {
//     batch3.insert('VUL1', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('VUL1_Temp');
// }
Future<void> insertVUL1(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteVUL1(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncVUL1();
  }
  print(customers);
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (var i = 0; i < customers.length; i += batchSize) {
    var end =
    (i + batchSize < customers.length) ? i + batchSize : customers.length;
    var batchRecords = customers.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (VUL1Model record in batchRecords) {
        try {
          batch.insert('VUL1_Temp', record.toJson());
        } catch (e) {
          writeToLogFile(
              text: e.toString(),
              fileName: StackTrace.current.toString(),
              lineNo: 141);
          getErrorSnackBar("Sync Error " + e.toString());
        }
      }
      await batch.commit();
    });
  }
  stopwatch.stop();
  print('Time taken for insert: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  var differenceList = await db.rawQuery('''
  Select * from (
			select * from VUL1_Temp
			except
			select * from VUL1
			)A
  ''');
  print(differenceList);
  for (var i = 0; i < differenceList.length; i += batchSize) {
    var end = (i + batchSize < differenceList.length)
        ? i + batchSize
        : differenceList.length;
    var batchRecords = differenceList.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var element in batchRecords) {
        try {
          batch.update("VUL1", element,
              where:
              "RowId = ? AND TransId = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["RowId"], element["TransId"], 1, 1]);
        } catch (e) {
          writeToLogFile(
              text: e.toString(),
              fileName: StackTrace.current.toString(),
              lineNo: 141);
          getErrorSnackBar("Sync Error " + e.toString());
        }
      }
      await batch.commit();
    });
  }

  stopwatch.stop();
  print('Time taken for VUL1 update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from VUL1_Temp where TransId || RowId not in (Select TransId || RowId from VUL1)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM VUL1_Temp T0
LEFT JOIN VUL1 T1 ON T0.TransId = T1.TransId AND T0.RowId = T1.RowId
WHERE T1.TransId IS NULL AND T1.RowId IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('VUL1', record);
        } catch (e) {
          writeToLogFile(
              text: e.toString(),
              fileName: StackTrace.current.toString(),
              lineNo: 141);
          getErrorSnackBar("Sync Error " + e.toString());
        }
      }
      await batch.commit();
    });
  }
  stopwatch.stop();
  print(
      'Time taken for VUL1_Temp and VUL1 compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('VUL1_Temp');
  // stopwatch.stop();
}

//SEND DATA TO SERVER
//--------------------------
Future<List<VUL1Model>> retrieveVUL1ById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('VUL1', where: str, whereArgs: l);
  return queryResult.map((e) => VUL1Model.fromJson(e)).toList();
}

Future<void> insertVUL1ToServer(BuildContext context) async {
  retrieveVUL1ById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "VUL1/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateVUL1OnServer(BuildContext? context) async {
  retrieveVUL1ById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'VUL1/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
