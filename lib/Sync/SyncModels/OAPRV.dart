import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:sqflite/sqlite_api.dart';

List<OAPRVModel> OAPRVModelFromJson(String str) =>
    List<OAPRVModel>.from(json.decode(str).map((x) => OAPRVModel.fromJson(x)));

String OAPRVModelToJson(List<OAPRVModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OAPRVModel {
  OAPRVModel({
    required this.ID,
    required this.DocName,
    required this.CreatedBy,
    required this.Active,
    required this.CreateDate,
    required this.UpdateDate,
    this.hasCreated = false,
    this.UpdatedBy,
    this.BranchId,
  });

  int ID;
  String DocName;
  DateTime CreateDate;
  DateTime UpdateDate;
  bool hasCreated;
  String CreatedBy;
  bool Active;
  String? UpdatedBy;
  String? BranchId;

  factory OAPRVModel.fromJson(Map<String, dynamic> json) => OAPRVModel(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        DocName: json["DocName"] ?? "",
        CreateDate: DateTime.tryParse(json["CreateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        UpdateDate: DateTime.tryParse(json["UpdateDate"].toString()) ??
            DateTime.parse("1900-01-01"),
        hasCreated: json['has_created'] == 1,
        CreatedBy: json["CreatedBy"] ?? "",
        Active: json["Active"] is bool ? json["Active"] : json["Active"] == 1,
        UpdatedBy: json['UpdatedBy'],
        BranchId: json['BranchId'],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "Active": Active == true ? 1 : 0,
        "DocName": DocName,
        "CreatedBy": CreatedBy,
        "CreateDate": CreateDate.toIso8601String(),
        "UpdateDate": UpdateDate.toIso8601String(),
        "has_created": hasCreated ? 1 : 0,
        'UpdatedBy': UpdatedBy,
        'BranchId': BranchId,
      };
}

Future<List<OAPRVModel>> dataSyncOAPRV() async {
  var res =
      await http.get(headers: header, Uri.parse(prefix + "OAPRV" + postfix));
  print(res.body);
  return OAPRVModelFromJson(res.body);
}

// Future<void> insertOAPRV(Database db)async{
//   if(postfix.toLowerCase().contains("all"))
//   await deleteOAPRV(db);
//   List customers= await dataSyncOAPRV();
//   print(customers);
//   var batch = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try
//     {
//       batch.insert('OAPRV', customer.toJson());
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
//   //       await db.insert('OAPRV', customer.toJson());
//   //     });
//   //   }
//   //   catch(e)
//   //   {
//   //     getErrorSnackBar("Sync Error "+e.toString());
//   //   }
//   //
//   // });
// }
// Future<void> insertOAPRV(Database db, {List? list}) async {
//   if (postfix.toLowerCase().contains('all')) {
//     await deleteOAPRV(db);
//   }
//   List customers;
//   if (list != null) {
//     customers = list;
//   } else {
//     customers = await dataSyncOAPRV();
//   }
//   print(customers);
//   var batch1 = db.batch();
//   var batch2 = db.batch();
//   var batch3 = db.batch();
//   customers.forEach((customer) async {
//     print(customer.toJson());
//     try {
//       batch1.insert('OAPRV_Temp', customer.toJson());
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
//       "SELECT * FROM  OAPRV_Temp WHERE 1=1 AND datetime(DATE('now'),'-3 days')<= (CASE WHEN UpdateDate IS NULL THEN CreateDate ELSE UpdateDate END)");
//   u.forEach((element) {
//     batch2.update("OAPRV", element,
//         where:
//             "DocName = ? AND CreatedBy = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
//         whereArgs: [element["DocName"], element["CreatedBy"], 1, 1]);
//   });
//   await batch2.commit(noResult: true);
//   var v = await db.rawQuery(
//       "Select * from OAPRV_Temp where DocName || CreatedBy  not in (Select DocName || CreatedBy from OAPRV)");
//   v.forEach((element) {
//     batch3.insert('OAPRV', element);
//   });
//   await batch3.commit(noResult: true);
//   await db.delete('OAPRV_Temp');
// }
Future<void> insertOAPRV(Database db, {List? list}) async {
  if (postfix.toLowerCase().contains('all')) {
    await deleteOAPRV(db);
  }
  List customers;
  if (list != null) {
    customers = list;
  } else {
    customers = await dataSyncOAPRV();
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
      for (OAPRVModel record in batchRecords) {
        try {
          batch.insert('OAPRV_Temp', record.toJson());
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
			select * from OAPRV_Temp
			except
			select * from OAPRV
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
          batch.update("OAPRV", element,
              where:
              "DocName = ? AND CreatedBy = ? AND ifnull(has_created,0) <> ? AND ifnull(has_updated,0) <> ?",
              whereArgs: [element["DocName"], element["CreatedBy"], 1, 1]);

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
  print('Time taken for OAPRV update: ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  stopwatch.start();
  // var v = await db.rawQuery("Select * from OAPRV_Temp where DocName || CreatedBy  not in (Select DocName || CreatedBy from OAPRV)");
  var v = await db.rawQuery('''
    SELECT T0.*
FROM OAPRV_Temp T0
LEFT JOIN OAPRV T1 ON T0.DocName = T1.DocName AND T0.CreatedBy = T1.CreatedBy
WHERE T1.DocName IS NULL AND T1.CreatedBy IS NULL;
''');
  for (var i = 0; i < v.length; i += batchSize) {
    var end = (i + batchSize < v.length) ? i + batchSize : v.length;
    var batchRecords = v.sublist(i, end);
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var record in batchRecords) {
        try {
          batch.insert('OAPRV', record);
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
      'Time taken for OAPRV_Temp and OAPRV compare : ${stopwatch.elapsedMilliseconds}ms');
  stopwatch.reset();
  print('Time taken for insertDataInTable: ${stopwatch.elapsedMilliseconds}ms');
  // stopwatch.start();
  // // await batch3.commit(noResult: true);
  await db.delete('OAPRV_Temp');
  // stopwatch.stop();
}

Future<List<OAPRVModel>> retrieveOAPRV(BuildContext context) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult = await db.query('OAPRV');
  return queryResult.map((e) => OAPRVModel.fromJson(e)).toList();
}

Future<void> updateOAPRV(
    int id, Map<String, dynamic> values, BuildContext context) async {
  final db = await initializeDB(context);
  try {
    db.transaction((db) async {
      await db.update("OAPRV", values, where: 'ID = ?', whereArgs: [id]);
    });
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    getErrorSnackBar("Sync Error " + e.toString());
  }
}

Future<void> deleteOAPRV(Database db) async {
  try {
    await db.delete('OAPRV');
  } catch (e) {
    writeToLogFile(
        text: e.toString(),
        fileName: StackTrace.current.toString(),
        lineNo: 141);
    print("Exception = ${e.toString()}");
  }
}

//SEND DATA TO SERVER
//--------------------------
Future<List<OAPRVModel>> retrieveOAPRVById(
    BuildContext? context, String str, List l) async {
  final Database db = await initializeDB(context);
  final List<Map<String, Object?>> queryResult =
      await db.query('OAPRV', where: str, whereArgs: l);
  return queryResult.map((e) => OAPRVModel.fromJson(e)).toList();
}

Future<void> insertOAPRVToServer(BuildContext context) async {
  retrieveOAPRVById(context, DataSync.getInsertToServerStr(),
          DataSync.getInsertToServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.post(Uri.parse(prefix + "OAPRV/Add"),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}

Future<void> updateOAPRVOnServer(BuildContext? context) async {
  retrieveOAPRVById(context, DataSync.getUpdateOnServerStr(),
          DataSync.getUpdateOnServerList())
      .then((snapshot) {
    print(snapshot);
    snapshot.forEach((data) async {
      var res = await http.put(Uri.parse(prefix + 'OAPRV/Update'),
          headers: header, body: jsonEncode(data.toJson()));
      print(res.body);
    });
  });
}
